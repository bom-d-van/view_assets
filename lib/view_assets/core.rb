module ViewAssets
  attr_accessor :js_assets, :css_assets
  
  def include_assets_with_assets_mvc
    raw [css_assets.all, js_assets.all].flatten.uniq.join("\n ")
  end

  def js_assets
    @_mvc_js_assets ||= JavascriptAssets.new(Rails.public_path, params[:controller], params[:action])
  end

  def css_assets
    @_mvc_css_assets ||= StyleSheetAssets.new(Rails.public_path, params[:controller], params[:action])
  end
end