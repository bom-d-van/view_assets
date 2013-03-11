module ActionView
  module ActionViewHelpers
    def retrieve_assets(controller, action)
      assets = []
      if Rails.env.production?
        css_manifest = File.open("#{Rails.public_path}/assets/#{ViewAssets::CSS_PATH}/manifest.yml", 'w').read
        js_manifest  = File.open("#{Rails.public_path}/assets/#{ViewAssets::JS_PATH}/manifest.yml", 'w').read

        css_location = css_manifest["/assets/#{controller}/#{action}.#{ViewAssets::CSS_EXT}"]
        css_location = css_manifest["/assets/#{controller}.#{ViewAssets::CSS_EXT}"] if js_location.nil?
        css_location = css_manifest["/assets/application.#{ViewAssets::CSS_EXT}"]   if js_location.nil?

        js_manifest["/assets/#{controller}/#{action}.#{ViewAssets::JS_EXT}"]
        js_location = js_manifest["/assets/#{controller}.#{ViewAssets::JS_EXT}"] if js_location.nil?
        js_location = js_manifest["/assets/application.#{ViewAssets::JS_EXT}"]   if js_location.nil?

        assets.push ViewAssets.tag(:css, css_location)
        assets.push ViewAssets.tag(:js, js_location)
      else
        assets.concat ViewAssets::Finder::CssFinder.new.retrieve(controller, action, :tagged => true)
        assets.concat ViewAssets::Finder::JsFinder.new.retrieve(controller, action, :tagged => true)
      end

      assets.map { |asset| raw(asset) }
    end
  end
end