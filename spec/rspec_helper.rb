RSPEC_ROOT = File.dirname(__FILE__)
$LOAD_PATH.unshift(RSPEC_ROOT + '/../lib/view_assets')

FIXTURE_ROOT = RSPEC_ROOT + '/fixtures'

class Rails
  def self.root
    FIXTURE_ROOT
  end
end

require 'view_assets'
include ViewAssets
include ViewAssets::JsAssetInfo
include ViewAssets::CssAssetInfo
