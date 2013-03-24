require File.expand_path("../rspec_helper", File.dirname(__FILE__))
require "view_assets/manager/map"

include ViewAssets::Manager

describe JsMap do
  let(:map) { JsMap.new }
  before(:each) do
    Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
  end

  # describe "#retrieve_manifests" do
  #   it "return manifests map" do
  #     expected_manifests = {
  #       :vendor => [
  #         PathInfo.new("vendor/javascripts/vendor1").abs,
  #         PathInfo.new("vendor/javascripts/vendor2/index").abs
  #       ],
  #       :lib => [
  #         PathInfo.new("lib/javascripts/lib1").abs,
  #         PathInfo.new("lib/javascripts/lib2/index").abs,
  #         PathInfo.new("lib/javascripts/lib4").abs
  #       ],
  #       :app => [
  #         PathInfo.new("app/javascripts/application").abs,
  #
  #         PathInfo.new("app/javascripts/controller1/action1").abs,
  #         PathInfo.new("app/javascripts/controller1/action2/index").abs,
  #
  #         PathInfo.new("app/javascripts/controller2/action1").abs,
  #         PathInfo.new("app/javascripts/controller2/action2/index").abs,
  #         PathInfo.new("app/javascripts/controller2/controller2").abs
  #       ]
  #     }
  #
  #     map.retrieve_manifests.should == expected_manifests
  #   end
  # end

  describe "#draw" do
    it "generate a hash map" do
      expected = {
        :vendor => {
          'vendor/javascripts/vendor1' => ['vendor/javascripts/vendor1.js'],
          'vendor/javascripts/vendor2' => ['vendor/javascripts/vendor2/index.js'],
          'vendor/javascripts/vendor3' => ['vendor/javascripts/vendor3/test.js']
        },
        :lib => {
          'lib/javascripts/lib1' => ['lib/javascripts/lib1.js'],
          'lib/javascripts/lib2' => ['lib/javascripts/lib2/index.js'],
          'lib/javascripts/lib3' => ['lib/javascripts/lib3/test.js'],
          'lib/javascripts/lib4' => [
            'lib/javascripts/lib1',
            'lib/javascripts/lib4.js'
          ],
        },
        :app => {
          'app/javascripts/application' => ['app/javascripts/application.js'],
          'app/javascripts/controller1/action1' => [
            'app/javascripts/application.js',
            'app/javascripts/controller1/action1.js'
          ],
          'app/javascripts/controller1/action2' => [
            'app/javascripts/application.js',
            'app/javascripts/controller1/action2/index.js'
          ],
          'app/javascripts/controller1/action3' => [
            'app/javascripts/application.js',
            'app/javascripts/controller1/action3/test.js'
          ],
          'app/javascripts/controller2/controller2' => [
            'app/javascripts/controller2/controller2.js'
          ],
          'app/javascripts/controller2/action1' => [
            'app/javascripts/controller2/controller2',
            'app/javascripts/controller2/action1.js'
          ],
          'app/javascripts/controller2/action2' => [
            'app/javascripts/controller2/controller2',
            'app/javascripts/controller2/action2/index.js'
          ],
          'app/javascripts/controller2/action3' => [
            'app/javascripts/controller2/controller2',
            'app/javascripts/controller2/action3/test.js'
          ]
        }
      }

      map.draw.should == expected
    end
  end
end