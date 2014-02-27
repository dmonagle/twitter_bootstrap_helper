$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "twitter_bootstrap_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "twitter_bootstrap_helper"
  s.version     = TwitterBootstrapHelper::VERSION
  s.authors     = ["David Monagle"]
  s.email       = ["david.monagle@intrica.com.au"]
  s.homepage    = "https://github.com/intrica/twitter_bootstrap_helper"
  s.summary     = "Helper methods for Rails to aid in creating Twitter Bootstrap Components"
  s.description = "Helper methods for Rails to aid in creating Twitter Bootstrap Components"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1"

  s.add_development_dependency "sqlite3"
end
