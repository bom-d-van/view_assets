require 'pathname'

##
# Introduction is in readme.md
module ViewAssets
  # TODO: figure out why can't use require in this case
  # TODO: find another way to include rake tasks, this method seems weird.
  load 'tasks/view_assets_tasks.rake' if defined?(Rake)
  
  APP_ROOT = Rails.root
  
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
