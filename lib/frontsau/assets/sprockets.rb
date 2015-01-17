module Frontsau
  module Assets
    class Sprockets < ::Sprockets::Environment
      attr_accessor :source_paths, :output_path

      def initialize
        super()
        self.output_path = File.expand_path Frontsau.config[:assets][:path]
        Frontsau.config[:assets][:sources].each do |glob_dir|
          Dir[File.expand_path(glob_dir)].each do |dir|
            append_path dir
          end
        end
        self.register_postprocessor 'text/css', UrlRewriter
      end

      def manifest
        m = {}
        compilable_paths.each do |path|
          asset = self[path]
          next unless asset.present?
          m[path] = {
              digest: asset.digest,
              modified: asset.mtime
          }
        end
        m
      end

      def compilable_paths
        return enum_for(:compilable_paths) unless block_given?
        each_logical_path do |path|
          Frontsau.config[:assets][:compile].each do |glob|
            yield path if File.fnmatch(glob, path)
            #puts "#{path} => #{glob} :: #{File.fnmatch(glob, path)}"
          end
        end
      end

      def dump path

        file = File.join output_path, path

        if !Dir.exist? File.dirname(file)
          FileUtils.mkpath File.dirname(file)
        end

        begin
          content = self[path].to_s
          File.write file, content
          return true
        rescue
          return false
        end

      end
    end
  end
end