require 'pathname'

# Introduction is in readme.md
module ViewAssets
  load 'tasks/view_assets_tasks.rake' if defined?(Rake)

  APP_ROOT = Rails.public_path

  APP_FOLDER = 'app'
  LIB_FOLDER = 'lib'
  VENDOR_FOLDER = 'vendor'

  JS_TYPE = 'javascript'
  JS_EXT = 'js'
  JS_PATH = 'javascripts'

  CSS_TYPE = 'css'
  CSS_EXT = 'css'
  CSS_PATH = 'stylesheets'

  require 'view_assets/error'
  require 'view_assets/path_info'
end
