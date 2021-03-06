# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frontsau/version'

Gem::Specification.new do |spec|
  spec.name          = "frontsau"
  spec.version       = Frontsau::VERSION
  spec.authors       = ["Benjamin Seibert"]
  spec.email         = ["benjamin.seibert@roomthirteen.de"]
  spec.summary       = %q{Frontsau, the new kid in frontend dev.}
  spec.description   = "Frontsau brings coffeescript, sass, less to any webapplication without big need of modifying it. No matter if your using wordpress, joomla, zend (only for the php ones)... and many more."
  spec.homepage      = "https://github.com/roomthirteen/frontsau"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "filewatcher", "~> 0.3"
  spec.add_dependency "rb-fsevent", "~> 0.9"
  spec.add_dependency "coffee-script", "~> 2.3"
  spec.add_dependency "sass", "~> 3.4"
  spec.add_dependency "less", "~> 2.6"
  spec.add_dependency "libv8", "~> 3.16"
  spec.add_dependency "therubyracer", "~> 0.12"
  spec.add_dependency "sprockets", "~> 2.12"
  spec.add_dependency "sinatra", "~> 1.4"
  spec.add_dependency "sinatra-contrib", "~> 1.4"
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "rack", "~> 1.6"
  spec.add_dependency "rack-cors", "~> 0.3"
  spec.add_dependency "ruby-progressbar", "~> 1.7"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10.1"

end
