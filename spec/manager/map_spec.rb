require File.expand_path("../rspec_helper", File.dirname(__FILE__))
require "view_assets/manager/map"

include ViewAssets::Manager

describe JsMap do
  let(:map) { JsMap.new }
  before(:each) do
    Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
  end

  describe "#retrieve_manifests" do
    it "return manifests map" do
      expected_manifests = {
        :vendor => [
          PathInfo.new("vendor/javascripts/vendor1").abs,
          PathInfo.new("vendor/javascripts/vendor2/index").abs
        ],
        :lib => [
          PathInfo.new("lib/javascripts/lib1").abs,
          PathInfo.new("lib/javascripts/lib2/index").abs
        ],
        :app => [
          PathInfo.new("app/javascripts/application").abs,
          PathInfo.new("app/javascripts/controler1/action1").abs,
          PathInfo.new("app/javascripts/controler1/action2/index").abs
        ]
      }

      map.retrieve_manifests.should == expected_manifests
    end
  end
end