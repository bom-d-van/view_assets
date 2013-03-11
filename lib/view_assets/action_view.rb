module ViewAssets
  module ActionViewHelpers
    require 'view_assets'
    require 'view_assets/finder/core'
    require 'yaml'

    def retrieve_assets(controller, action)
      assets = []
      if Rails.env.production?
        css_path     = "/assets/#{ViewAssets::CSS_PATH}"
        js_path      = "/assets/#{ViewAssets::JS_PATH}"
        css_manifest = YAML.load(File.open("#{Rails.public_path}#{css_path}/manifest.yml").read)
        js_manifest  = YAML.load(File.open("#{Rails.public_path}#{js_path}/manifest.yml").read)

        case
        when css_location = css_manifest["#{css_path}/#{controller}_#{action}.#{ViewAssets::CSS_EXT}"]
        when css_location = css_manifest["#{css_path}/#{controller}.#{ViewAssets::CSS_EXT}"]
        when css_location = css_manifest["#{css_path}/application.#{ViewAssets::CSS_EXT}"]
        end

        case
        when js_location = js_manifest["#{js_path}/#{controller}_#{action}.#{ViewAssets::JS_EXT}"]
        when js_location = js_manifest["#{js_path}/#{controller}.#{ViewAssets::JS_EXT}"]
        when js_location = js_manifest["#{js_path}/application.#{ViewAssets::JS_EXT}"]
        end

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