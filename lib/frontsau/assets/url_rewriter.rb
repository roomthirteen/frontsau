module Frontsau
  module Assets
    class UrlRewriter < ::Sprockets::Processor
      def evaluate(context, locals)
        data.gsub /(?<=[:\s])url\(['"]?([^\s)]+\.[a-z]+)(\?\d+)?['"]?\)/i do |url|
          uri = URI.parse($1)
          #puts uri
          next url if uri.absolute?
          parts = uri.path.split '/'
          # remove ../image
          parts.shift
          parts.shift
          # add assets base path
          parts.unshift Frontsau.config[:assets][:path]
          rewritten_url = '/'+parts.join('/')
          #puts "Rewriting #{uri.path} to #{rewritten_url}"
          next "url(#{rewritten_url})"
        end
      end
    end
  end
end