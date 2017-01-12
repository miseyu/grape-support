lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'grape/support/version'

Gem::Specification.new do |spec|
  spec.name          = "grape-support"
  spec.version       = Grape::Support::VERSION
  spec.authors       = ["Yuji Mise"]
  spec.email         = ["miseyu2000@gmail.com"]
  spec.summary       = %q{Grape project support library}
  spec.description   = %q{Grape project support library}
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", '>= 4.0.0'
  spec.add_dependency "grape", '>= 0.11.0'
  spec.add_dependency "grape-entity", '>= 0.4.5'
  spec.add_dependency "redic"
  spec.add_dependency "kaminari"
  spec.add_dependency "hashie"
  spec.add_dependency "her"
  spec.add_dependency "request_store"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails" , "~> 2.14.0"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "factory_girl_rails"

end
