module Frontsau
  module Assets
    class Watcher

      EXT_MAP = {
          ".haml" => ".html",
          ".less" => ".css",
          ".sass" => ".css",
          ".coffee" => ".js",
      }

      def initialize &callback
        @callback = callback
        @watches = Frontsau.config[:assets][:sources].map{|s| Dir[s] }.flatten.uniq
        filewatcher()
      end

      def filewatcher
       FileWatcher.new(@watches).watch do |file|
         next if File.directory? file
         @watches.each do |p|
           if p.start_with? p
             file = file.gsub "#{p}/", ""
           end
           file
         end
         ext = File.extname file
         base = File.basename file, ext
         dir = File.dirname file
         if EXT_MAP[ext.downcase].present?
           ext = EXT_MAP[ext.downcase]
         end
         @callback.call "#{dir}/#{base}#{ext}"
       end
      end

      def fsevent
        fsevent = FSEvent.new
        opts = {
            watch_root: true,
            file_events: true
        }
        fsevent.watch @watches do |path|
          puts path
        end
        fsevent.run
      end

      def inotify
        notifier = INotify::Notifier.new
        @watches.each do |path|
          notifier.watch path do
            puts "wee #{path}"
          end
        end
        notifier.run
      end
    end
  end
end