module Frontsau
  class ThorApp < Thor

    include Thor::Actions

    desc "compile", "Compiles all available assets."
    def compile
      say "Dumping assets:"
      inside Frontsau.assets_path do
        paths = Frontsau.sprockets.compilable_paths
        manifest = {}
        p = ProgressBar.create(
            total: paths.count,
            format: "   %p% | %B"
        )
        paths.each do |path|
          p.increment
          begin
            asset = Frontsau.sprockets[path]
            data = asset.to_s
            create_file path, data, force: true, verbose: false
            manifest[path] = {
              digest: asset.digest,
              modified: asset.mtime
            }
          rescue Exception => e
            say ""
            say ""
            say "#{e.class.name} ", :red
            say "#{e.message}"
            say ""
            say ""
          end
        end
        say ""
        create_file "manifest.json", JSON.pretty_generate(manifest), force: true
      end
    end

    desc "clean", "Removes all precompiled artefacts."
    def clean
      Dir[Frontsau.config[:assets][:path]+"/*"].each do |f|
        remove_file f
      end
    end


    desc "watch", "Watches for filechanges and compiles to the asset path immediatly."
    def watch
      compile
      say "Watching for asset changes:"
      Frontsau::Assets::Watcher.new do |path|
        begin
          asset = Frontsau.sprockets[path]
          create_file path, asset.to_s, force: true, verbose: true
        rescue Exception => e
          say ""
          say ""
          say "#{e.class.name} ", :red
          say "#{e.message}"
          say ""
          say ""
        end
      end
    end


    desc "debug WHAT", "Dump all logical asset paths to the console."
    def debug what = "all"
      puts ""
      if what == "all"
        Frontsau.sprockets.each_logical_path do |path|
          puts "  #{path}"
        end
      elsif
        Frontsau.sprockets.compilable_paths.each do |path|
          puts "  #{path}"
        end
      end
      puts ""
    end

    desc "server", "Starts a local assets server."
    def server
      app = Rack::Builder.new do
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use Rack::Cors do
          allow do
            origins '*'
            resource '*'
          end
        end
        map "/" do
          run Frontsau::Assets::Rack.new
        end
        map "/#{Frontsau.config[:assets][:path]}" do
          run Frontsau.sprockets
        end
      end
      Rack::Handler::WEBrick.run app, :Port => 9292
    end

    desc "haml", "Compiles a phampl template."
    def haml input
      if !File.exist? input
        raise "Input file does not exist!"
      end
      path = File.dirname input
      name = File.basename input, '.haml'
      tool_root = File.dirname(File.dirname(File.dirname(__FILE__)))
      cmd = File.join(tool_root,"bin/frontsau-phaml-compiler")
      html = `#{cmd} '#{input}'`
      output = File.join(path,"#{name}.php")
      File.write output, html
    end
  end
end