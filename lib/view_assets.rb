##
# TODO documentation
module ViewAssets
  require 'pathname'

  require 'view_assets/error'
  require 'view_assets/directives'
  require 'view_assets/assets_finder'
  require 'view_assets/js_assets'
  require 'view_assets/css_assets'

  ##
  # To verify all assets and throw exception when find out inexistent asset
  # Defaults to turn off. DO NOT use it in production.
  # todo find out how to document constant
  TO_VERIFY = false
  
  attr_accessor :js_assets, :css_assets
  
  # TODO need a new controller-action configuring interface, try to configure them in helper instead of view files
  def include_assets_with_assets_mvc(controller, action)
    @va_controller = controller
    @va_action = action
    
    raw [css_assets.all, js_assets.all].flatten.uniq.join("\n ")
  end

  def js_assets
    @va_js_assets ||= JavascriptAssets.new(Rails.public_path, @va_controller, @va_action)
  end

  def css_assets
    @va_css_assets ||= StyleSheetAssets.new(Rails.public_path, @va_controller, @va_action)
  end
end