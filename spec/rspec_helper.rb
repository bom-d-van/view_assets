$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib/view_assets')

class Rails
  def self.root; end
end

require 'view_assets'
include ViewAssets
