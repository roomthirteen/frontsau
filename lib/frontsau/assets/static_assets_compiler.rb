require 'filewatcher'
require 'coffee-script'
require 'sass'
require 'pry'

module Frontsau

  class StaticAssetsCompiler
    def is_type type, file
      filetype = File.extname file
      filetype == ".#{type}"
    end

    def compile_coffee file
      filename = File.basename file,'.*'
      type = File.extname file
      path = File.dirname file
      input = File.read file
      output = "// FILE GENERATED FROM #{filename}.coffee\n\n"+CoffeeScript.compile(input)
      output_file = File.expand_path "#{filename}.js",path
      File.write output_file,output
    end


    def compile_sass file
      filename = File.basename file,'.*'
      type = File.extname file
      path = File.dirname file
      input = File.read file
      paths = Dir['plugins/*/static/css', 'vendor/bower/compass/core/stylesheets', 'vendor/bower']
      output = "/* FILE GENERATED FROM #{filename}.sass */\n\n"+Sass.compile(input, syntax: :sass, load_paths: paths)
      output_file = File.expand_path "#{filename}.css",path
      File.write output_file,output
    end

    def compile_haml file
      `php plugins/Room13Web/bin/haml-compiler.php #{file}`
    end

    def compile file, type
      puts "  => #{file}"
      begin
        send "compile_#{type}", file
      rescue => e
        puts ""
        puts "    --------------------------------------------"
        puts "    ERROR: "+e.message
        puts "    --------------------------------------------"
        puts ""
      end
    end
  end


end