module Frontsau
  module Assets
    class Rack < Sinatra::Base
      get '/debug' do
        json Frontsau.sprockets.compilable_paths
      end
      get '/manifest.json' do
        json Frontsau.sprockets.manifest
      end
    end
  end
end