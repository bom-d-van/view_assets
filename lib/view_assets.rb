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

  def tag(type, url)
    case type
    when :js
      %(<script src="#{url}" type="text/javascript"></script>)
    when :css
      %(<link href="#{url}" media="screen" rel="stylesheet" />)
    else
      raise Error.new("Unknown tag type")
    end
  end

  module_function :tag

  require 'view_assets/error'
  require 'view_assets/path_info'
end
