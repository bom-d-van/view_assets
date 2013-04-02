$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "view_assets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "view_assets"
  s.version     = ViewAssets::VERSION
  s.authors     = ["Van Hu"]
  s.email       = ["bom.d.van@gmail.com"]
  s.homepage    = "https://github.com/bom-d-van/view_assets"
  s.summary     = "A new method to manage assets in a rails project."
  s.description = "Instead of using the default assets managing style in rails 3.2, this gem will introduce a new way to manage your assets. This is still a prototype, the fullfledged version will publish soon."
  s.files       = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "readme.md"]
  s.license     = "MIT-LICENSE"
  s.test_files  = Dir["test/**/*"]

  s.add_dependency "yui-compressor"
  s.add_dependency "uglifier"
  s.add_dependency "closure-compiler"
  s.add_dependency "term-ansicolor"

  s.add_development_dependency "rails", "~> 3.2.8"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "ZenTest"
  # rails.add_development_dependency "rspec-nc"
end
