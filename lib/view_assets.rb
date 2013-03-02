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
  
  require 'view_assets/path_info'
  
  # module AssetPathKnowable
  #   def root
  #     Pathname.new(APP_ROOT)
  #   end
  #   
  #   def app_path
  #     Pathname.new("#{APP_ROOT}/#{APP_FOLDER}/assets")
  #   end
  # 
  #   def lib_path
  #     Pathname.new("#{APP_ROOT}/#{LIB_FOLDER}/assets")
  #   end
  # 
  #   def vendor_path
  #     Pathname.new("#{APP_ROOT}/#{VENDOR_FOLDER}/assets")
  #   end
  # end

  # require 'view_assets/error'
  # require 'view_assets/info'
  # require 'view_assets/directives'
  # require 'view_assets/assets_finder'
  # require 'view_assets/js_assets'
  # require 'view_assets/css_assets'
  # require 'view_assets/path'
  # require 'view_assets/action_map'
  
  # attr_accessor :js_assets, :css_assets
  # 
  # # TODO need a new controller-action configuring interface, try to configure them in helper instead of view files.
  # def include_assets_with_assets_mvc(controller, action)
  #   @va_controller = controller
  #   @va_action = action
  # 
  #   raw [css_assets.all, js_assets.all].flatten.uniq.join("\n ")
  # end
  # 
  # def js_assets
  #   @va_js_assets ||= JsAssets.new(Rails.public_path, @va_controller, @va_action)
  # end
  # 
  # def css_assets
  #   @va_css_assets ||= StyleSheetAssets.new(Rails.public_path, @va_controller, @va_action)
  # end
end
