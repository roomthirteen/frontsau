require 'sprockets'
require 'sass'
require 'coffee-script'

module Frontsau
  module Assets
    class Sprockets < ::Sprockets::Environment
      attr_accessor :source_paths, :output_path
      def initialize source_paths, output_path

        self.source_paths = source_paths
        self.output_path = output_path
        super()
        source_paths.each do |dir|
          append_path dir
        end
      end


      SUPPORTED_FILES_TYPES = [".css",".js"]

      def each_supported_logical_path
        each_logical_path.to_a.delete_if do |p|
          !SUPPORTED_FILES_TYPES.include? File.extname(p).downcase
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