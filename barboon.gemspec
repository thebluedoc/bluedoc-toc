$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "barboon/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "barboon"
  s.version     = Barboon::VERSION
  s.authors     = ["Jason Lee"]
  s.email       = ["huacnlee@gmail.com"]
  s.homepage    = "https://github.com/huacnlee/barboom"
  s.summary     = "Summary of Barboon."
  s.description = "Description of Barboon."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "mysql2"
end
