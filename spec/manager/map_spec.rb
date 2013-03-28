require File.expand_path("../rspec_helper", File.dirname(__FILE__))
require "view_assets/manager/manager"

include ViewAssets::Manager

shared_examples "manager map" do |dir, ext|
  describe "#draw" do
    it "generate a hash map" do
      expected = {
        :vendor => {
          "vendor/#{dir}/vendor1" => ["vendor/#{dir}/vendor1.#{ext}"],
          "vendor/#{dir}/vendor2" => ["vendor/#{dir}/vendor2/index.#{ext}"],
          "vendor/#{dir}/vendor3" => ["vendor/#{dir}/vendor3/test.#{ext}"]
        },
        :lib => {
          "lib/#{dir}/lib1" => ["lib/#{dir}/lib1.#{ext}"],
          "lib/#{dir}/lib2" => ["lib/#{dir}/lib2/index.#{ext}"],
          "lib/#{dir}/lib3" => ["lib/#{dir}/lib3/test.#{ext}"],
          "lib/#{dir}/lib4" => [
            "lib/#{dir}/lib1",
            "lib/#{dir}/lib4.#{ext}"
          ],
          "lib/#{dir}/lib5" => [
            "lib/#{dir}/lib3/test",
            "lib/#{dir}/lib5.#{ext}"
          ],
        },
        :app => {
          "app/#{dir}/application" => ["app/#{dir}/application.#{ext}"],
          "app/#{dir}/controller1/action1" => [
            "app/#{dir}/application",
            "vendor/#{dir}/vendor1",
            "lib/#{dir}/lib4",
            "app/#{dir}/controller1/action3/test.#{ext}",
            "app/#{dir}/controller2/action3/test.#{ext}",
            "app/#{dir}/controller1/action1.#{ext}"
          ],
          "app/#{dir}/controller1/action2" => [
            "app/#{dir}/application",
            "app/#{dir}/controller1/action2/index.#{ext}"
          ],
          "app/#{dir}/controller1/action3" => [
            "app/#{dir}/application",
            "app/#{dir}/controller1/action3/test.#{ext}"
          ],
          "app/#{dir}/controller2/controller2" => [
            "app/#{dir}/controller2/controller2.#{ext}"
          ],
          "app/#{dir}/controller2/action1" => [
            "app/#{dir}/controller2/controller2",
            "app/#{dir}/controller2/action1.#{ext}"
          ],
          "app/#{dir}/controller2/action2" => [
            "app/#{dir}/controller2/controller2",
            "app/#{dir}/controller2/action2/index.#{ext}"
          ],
          "app/#{dir}/controller2/action3" => [
            "app/#{dir}/controller2/controller2",
            "app/#{dir}/controller2/action3/test.#{ext}"
          ]
        }
      }

      map.draw.should == expected
    end
  end
end

describe JsMap do
  let(:map) { JsMap.new }
  before(:each) do
    Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
  end
  include_examples "manager map", JS_PATH, JS_EXT
end

describe CssMap do
  let(:map) { CssMap.new }
  before(:each) do
    Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
  end
  include_examples "manager map", CSS_PATH, CSS_EXT
end