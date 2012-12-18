RSPEC_ROOT = File.dirname(__FILE__)
$LOAD_PATH.unshift(RSPEC_ROOT + '/../lib/view_assets')
require 'view_assets'
include ViewAssets
FIXTURE_ROOT = RSPEC_ROOT + '/fixtures'
