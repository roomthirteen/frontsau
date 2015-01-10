require 'rack'
require 'pimtool/assets/debug_rack_app'
require 'filewatcher'

module Pimtool
  class ThorApp < Thor

    desc "compile", "Compiles all available assets."
    def compile
      say "Dumping assets:"
      $sprockets.each_supported_logical_path.each do |path|
        say "   #{path}"
        $sprockets.dump path

      end
    end

    desc "debug", "Dump all logical asset paths to the console."
    def debug
      puts ""
      $sprockets.each_supported_logical_path.each do |path|
        puts "  #{path}"
      end
      puts ""
    end

    desc "server", "Starts a local assets server."
    def server
      app = Rack::Builder.new do
        use Rack::CommonLogger
        use Rack::ShowExceptions
        map "/debug" do
          run Pimtool::Assets::DebugRackApp.new
        end
        map "/" do
          run $sprockets
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
      cmd = File.join(tool_root,"bin/pimtool-phaml-compiler")
      html = `#{cmd} '#{input}'`
      output = File.join(path,"#{name}.php")
      File.write output, html
    end


    desc "watch", "Watch for file changes to handle"
    def watch
      targets = [
          "plugins/**/*.haml",
          "website/**/*.haml"
      ]
      puts "Precompiling all files"
      targets.each do |target|
        Dir[target].each do |file|
          puts "  => #{file}"
        end
      end
      puts "Waiting for changes"
      FileWatcher.new(targets).watch do |file|
        puts "  => #{file}"
        type = File.extname(file)[1..-1].to_sym
        if type == :haml
          haml file
        end
      end
    end


  end
end