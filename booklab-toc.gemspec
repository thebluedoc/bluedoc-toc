$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "bluedoc/toc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bluedoc-toc"
  s.version     = BlueDoc::Toc::VERSION
  s.authors     = ["Jason Lee"]
  s.email       = ["huacnlee@gmail.com"]
  s.homepage    = "https://github.com/thebluedoc/bluedoc-toc"
  s.summary     = "Toc format read/write for BlueDoc"
  s.description = "Toc format read/write for BlueDoc"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"

  s.add_development_dependency "mysql2"
end
