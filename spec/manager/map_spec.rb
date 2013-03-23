require File.expand_path("../rspec_helper", File.dirname(__FILE__))
require "view_assets/manager/map"

include ViewAssets::Manager

describe JsMap do
  let(:map) { JsMap.new }
  before(:each) do
    Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
  end

  # describe "#retrieve_manifests" do
  #   expected_manifests = {
  #     :vendor => [
  #       "vendor/javascripts/vendor1.js"
  #       "vendor/javascripts/vendor2.js"
  #     ],
  #     :lib => [
  #       "lib/javascripts/lib1.js"
  #       "lib/javascripts/lib2.js"
  #     ],
  #     :app => [
  #       "app/javascripts/controller1/action1.js"
  #       "app/javascripts/controller1/action2/index.js"
  #     ]
  #   }
  # end
end