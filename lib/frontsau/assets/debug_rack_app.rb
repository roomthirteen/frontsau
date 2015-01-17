require 'sinatra/base'
require 'sinatra/json'

module Frontsau
  module Assets
    class DebugRackApp < Sinatra::Base
      get '/' do
        json $sprockets.each_logical_path.to_a
      end
    end
  end
end