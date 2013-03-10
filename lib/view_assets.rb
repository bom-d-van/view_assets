require 'pathname'

# Introduction is in readme.md
module ViewAssets
  require 'view_assets/railtie'

  APP_FOLDER = 'app'
  LIB_FOLDER = 'lib'
  VENDOR_FOLDER = 'vendor'

  JS_TYPE = 'javascript'
  JS_EXT = 'js'
  JS_PATH = 'javascripts'

  CSS_TYPE = 'css'
  CSS_EXT = 'css'
  CSS_PATH = 'stylesheets'

  # Load Tasks
  # Dir.glob(File.dirname(__FILE__) + '/tasks/*.rake').each { |task| load(task) } if defined?(Rake)

  require 'view_assets/error'
  require 'view_assets/path_info'
end
