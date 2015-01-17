# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frontsau/version'

Gem::Specification.new do |spec|
  spec.name          = "frontsau"
  spec.version       = Frontsau::VERSION
  spec.authors       = ["Benjamin Seibert"]
  spec.email         = ["benjamin.seibert@roomthirteen.de"]
  spec.summary       = %q{Have your assets allways at ease with frontsau.}
  spec.description   = %q{Have your assets allways at ease with frontsau.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "filewatcher", "~> 0.3.6"
  spec.add_dependency "coffee-script", "~> 2.3.0"
  spec.add_dependency "sass", "~> 3.4.9"
  spec.add_dependency "less", "~> 2.6.0"
  spec.add_dependency "libv8", "~> 3.16.14.0"
  spec.add_dependency "sprockets", "~> 2.12.3"
  spec.add_dependency "sinatra", "~> 1.4.5"
  spec.add_dependency "sinatra-contrib", "~> 1.4.2"
  spec.add_dependency "thor", "~> 0.19.1"


  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10.1"

end
