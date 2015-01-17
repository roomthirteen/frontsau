require 'filewatcher'
require 'pry'
require 'pathname'
require 'uri'

require 'rack'
require 'rack/cors'
require 'sinatra/base'
require 'sinatra/json'

require 'sprockets'
require 'tilt'
require 'coffee-script'
require 'sass'
require 'less'

require 'frontsau/version'
require 'frontsau/assets/sprockets'
require 'frontsau/assets/url_rewriter'
require 'frontsau/assets/rack'
require 'frontsau/assets/watcher'
require 'ruby-progressbar'

require 'rb-fsevent'
#require 'rb-inotify'
require 'filewatcher'

module Frontsau

  mattr_accessor :config
  mattr_accessor :root_path
  mattr_accessor :sprockets

  def self.init root_path

    # define project root
    self.root_path = root_path

    # load configuration
    config_file = File.expand_path '.frontsau'
    raise "No .frontsau found in #{root_path}!" unless File.exists? config_file
    raw_config = YAML.load File.read config_file
    self.config = ActiveSupport::HashWithIndifferentAccess.new raw_config['frontsau']


    #Sprockets::Engines
    #Sprockets.register_engine '.haml', Tilt::HamlTemplate


    # initialize sprockets
    self.sprockets = Frontsau::Assets::Sprockets.new
    sprockets.cache = Sprockets::Cache::FileStore.new(config[:assets][:cache])

  end

  def self.assets_path
    config[:assets][:path]
  end

  def self.asset_path path
    assets_path+path
  end

end
