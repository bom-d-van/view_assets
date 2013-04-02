require File.expand_path("../rspec_helper", File.dirname(__FILE__))
require "view_assets/manager/manager"
include ViewAssets::Manager

shared_examples "modifier" do |dir, ext|
  describe "#update_requirements" do
    modifier_fixtures_path = File.expand_path("fixtures/modifier", File.dirname(__FILE__))
    back_up_modifier_fixtures_path = "#{modifier_fixtures_path}.backup"
    before(:all) do
      FileUtils.cp_r(modifier_fixtures_path, back_up_modifier_fixtures_path)
    end

    after(:all) do
      FileUtils.rm_rf(modifier_fixtures_path)
      FileUtils.mv(back_up_modifier_fixtures_path, modifier_fixtures_path)
    end

    before(:each) do
      Rails.stub(:public_path).and_return(modifier_fixtures_path)

      FileUtils.rm_rf(modifier_fixtures_path)
      FileUtils.cp_r(back_up_modifier_fixtures_path, modifier_fixtures_path)
    end

    it "remove requirements when new_index is empty" do
      lib5 = "lib/#{dir}/lib5"

      modifier.map[:lib]["lib/#{dir}/lib1"].include?(lib5).should == true
      modifier.map[:app]["app/#{dir}/controller2/action1"].include?(lib5).should == true

      modifier.update_requirements(lib5, '')
      modifier.update_map

      modifier.map[:lib]["lib/#{dir}/lib1"].include?(lib5).should == false
      modifier.map[:app]["app/#{dir}/controller2/action1"].include?(lib5).should == false
    end
  end

  describe "#modify" do
    before(:each) do
      Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
    end

    it "update requirement blocks" do
      content = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vivamus vitae risus vitae lorem iaculis placerat. Aliquam sit amet felis. Etiam congue. Donec risus risus, pretium ac, tincidunt eu, tempor eu, quam. Morbi blandit mollis magna. Suspendisse eu tortor. Donec vitae felis nec ligula blandit rhoncus. Ut a pede ac neque mattis facilisis. Nulla nunc ipsum, sodales vitae, hendrerit non, imperdiet ac, ante. Morbi sit amet mi. Ut magna. Curabitur id est. Nulla velit. Sed consectetuer sodales justo. Aliquam dictum gravida libero. Sed eu turpis. Nunc id lorem. Aenean consequat tempor mi. Phasellus in neque. Nunc fermentum convallis ligula."
      fake_asset = PathInfo.new("fake-asset.#{ext}").abs
      File.open(fake_asset, "w") do |file|
        file << "/*= require_vendor vendor1 */\n"
        file << "/*= require_lib lib1 */\n"

        file << content
      end
      block =   ["/**"]
      block.push(" *= require_vendor vendor2")
      block.push(" *= require_lib lib2")
      block.push(" */")

      modifier.modify("fake-asset", block.join("\n"))

      File.new(fake_asset).read.should == block.join("\n") + content

      FileUtils.remove(fake_asset)
    end
  end

  describe "#generate_requirements_block" do
    before(:each) do
      Rails.stub(:public_path).and_return(File.expand_path("fixtures/modifier", File.dirname(__FILE__)))
    end

    it "generate requirements block" do
      new_block = modifier.generate_requirements_block(
                    "app/#{dir}/controller/action",
                    %W(
                      app/#{dir}/controller/controller
                      app/#{dir}/application
                      vendor/#{dir}/vendor1
                      lib/#{dir}/lib1
                      app/#{dir}/controller2/action2/something
                      app/#{dir}/controller/action2/something
                      app/#{dir}/controller/action/something.#{ext}
                      app/#{dir}/controller/action/index.#{ext}
                      app/#{dir}/controller/action.#{ext}
                    )
                  )

      new_block.should == [
                            "/**",
                            " *= require_vendor vendor1",
                            " *= require_lib lib1",
                            " *= require /controller2/action2/something",
                            " *= require /controller/action2/something",
                            " */"
                          ].join("\n") + "\n"
    end
  end

  describe "#update" do
    modifier_fixtures_path = File.expand_path("fixtures/modifier", File.dirname(__FILE__))
    back_up_modifier_fixtures_path = "#{modifier_fixtures_path}.backup"
    before(:all) do
      FileUtils.cp_r(modifier_fixtures_path, back_up_modifier_fixtures_path)
    end

    after(:all) do
      FileUtils.rm_rf(modifier_fixtures_path)
      FileUtils.mv(back_up_modifier_fixtures_path, modifier_fixtures_path)
    end

    before(:each) do
      Rails.stub(:public_path).and_return(modifier_fixtures_path)

      FileUtils.rm_rf(modifier_fixtures_path)
      FileUtils.cp_r(back_up_modifier_fixtures_path, modifier_fixtures_path)
    end

    context "when updating lib index" do
      it "update index file name" do
        modifier.update("lib/#{dir}/lib2", "lib/#{dir}/lib2-1")
        modifier.update_map

        modifier.map[:lib].key?("lib/#{dir}/lib2-1").should == true
        modifier.map[:lib].key?("lib/#{dir}/lib2").should == false
      end

      it "update requirements" do
        modifier.update("lib/#{dir}/lib5", "lib/#{dir}/lib5-1")
        modifier.update_map

        modifier.map[:lib].key?("lib/#{dir}/lib5-1").should == true
        modifier.map[:lib].key?("lib/#{dir}/lib5").should == false

        modifier.map[:lib]["lib/#{dir}/lib1"].include?("lib/#{dir}/lib5-1").should == true
        modifier.map[:lib]["lib/#{dir}/lib1"].include?("lib/#{dir}/lib5").should == false

        action1 = modifier.map[:app]["app/#{dir}/controller2/action1"]
        action1.include?("lib/#{dir}/lib5-1").should == true
        action1.include?("lib/#{dir}/lib5").should == false
      end
    end

    it "update vendor index" do
      modifier.update("vendor/#{dir}/vendor1", "vendor/#{dir}/vendor1-1")
      modifier.update_map

      modifier.map[:vendor].key?("vendor/#{dir}/vendor1-1").should == true
      modifier.map[:vendor].key?("vendor/#{dir}/vendor1").should == false
      modifier.map[:vendor]["vendor/#{dir}/vendor1-1"].include?("vendor/#{dir}/vendor1-1.#{ext}").should == true
      modifier.map[:vendor]["vendor/#{dir}/vendor1-1"].include?("vendor/#{dir}/vendor1.#{ext}").should == false

      action1 = modifier.map[:app]["app/#{dir}/controller1/action1"]
      action1.include?("vendor/#{dir}/vendor1-1").should == true
      action1.include?("vendor/#{dir}/vendor1").should == false
    end

    it "update app index" do
      modifier.update("app/#{dir}/controller1/action1", "app/#{dir}/controller1/action1-1")
      modifier.update_map

      modifier.map[:app].key?("app/#{dir}/controller1/action1-1").should == true
      modifier.map[:app].key?("app/#{dir}/controller1/action1").should == false
      modifier.map[:app]["app/#{dir}/controller1/action1-1"].include?("app/#{dir}/controller1/action1-1.#{ext}").should == true
      modifier.map[:app]["app/#{dir}/controller1/action1-1"].include?("app/#{dir}/controller1/action1.#{ext}").should == false

      action1 = modifier.map[:app]["app/#{dir}/controller1/action1-1"]
      action1.include?("app/#{dir}/controller1/action1-1.#{ext}").should == true
      action1.include?("app/#{dir}/controller1/action1.#{ext}").should == false
    end
  end

  describe "#remove" do
    modifier_fixtures_path = File.expand_path("fixtures/modifier", File.dirname(__FILE__))
    back_up_modifier_fixtures_path = "#{modifier_fixtures_path}.backup"
    before(:all) do
      FileUtils.cp_r(modifier_fixtures_path, back_up_modifier_fixtures_path)
    end

    after(:all) do
      FileUtils.rm_rf(modifier_fixtures_path)
      FileUtils.mv(back_up_modifier_fixtures_path, modifier_fixtures_path)
    end

    before(:each) do
      Rails.stub(:public_path).and_return(modifier_fixtures_path)

      FileUtils.rm_rf(modifier_fixtures_path)
      FileUtils.cp_r(back_up_modifier_fixtures_path, modifier_fixtures_path)
    end

    it "remove requirements when new_index is empty" do
      lib5 = "lib/#{dir}/lib5"

      modifier.map[:lib].include?(lib5).should == true
      modifier.map[:lib]["lib/#{dir}/lib1"].include?(lib5).should == true
      modifier.map[:app]["app/#{dir}/controller2/action1"].include?(lib5).should == true

      modifier.remove(lib5)
      modifier.update_map

      modifier.map[:lib].include?(lib5).should == false
      modifier.map[:lib]["lib/#{dir}/lib1"].include?(lib5).should == false
      modifier.map[:app]["app/#{dir}/controller2/action1"].include?(lib5).should == false
    end
  end
end

describe "JsModifier" do
  let(:modifier) { JsModifier.new }
  include_examples "modifier", JS_PATH, JS_EXT
end

describe "CssModifier" do
  let(:modifier) { CssModifier.new }
  include_examples "modifier", CSS_PATH, CSS_EXT
end