require File.expand_path('./packager_helper', File.dirname(__FILE__))

PACKAGER_TEST_ROOT = "#{File.dirname(__FILE__)}/fixtures/packager"

describe JsPackager do
  before(:each) do
    JsFinder.any_instance.stub(:root).and_return(PACKAGER_TEST_ROOT)
    JsPackager.any_instance.stub(:root).and_return(PACKAGER_TEST_ROOT)
    PathInfo.any_instance.stub(:root).and_return(PACKAGER_TEST_ROOT)
  end

  describe "#package" do
    it "package javascript assets" do
      FileUtils.rm_r(Dir.glob("#{PACKAGER_TEST_ROOT}/assets/#{JS_PATH}/*"))
      JsPackager.new.package
      expected = %w(
        controller1_action1-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action10-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action11-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action12-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action2-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action3-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action4-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action5-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action6-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action7-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action8-d41d8cd98f00b204e9800998ecf8427e.js
        controller1_action9-d41d8cd98f00b204e9800998ecf8427e.js
        controller2_action1-d41d8cd98f00b204e9800998ecf8427e.js
        controller2_action2-d41d8cd98f00b204e9800998ecf8427e.js
        controller3_action1-d41d8cd98f00b204e9800998ecf8427e.js
      ).map { |file| "#{PACKAGER_TEST_ROOT}/assets/#{JS_PATH}/#{file}" }

      Dir["#{PACKAGER_TEST_ROOT}/assets/#{JS_PATH}/*.js"].should == expected
    end
  end
end

describe CssPackager do
  before(:each) do
    CssFinder.any_instance.stub(:root).and_return(PACKAGER_TEST_ROOT)
    CssPackager.any_instance.stub(:root).and_return(PACKAGER_TEST_ROOT)
    PathInfo.any_instance.stub(:root).and_return(PACKAGER_TEST_ROOT)
  end

  describe "#package" do
    it "package javascript assets" do
      FileUtils.rm_r(Dir.glob("#{PACKAGER_TEST_ROOT}/assets/#{CSS_PATH}/*"))

      CssPackager.new.package
      expected = %w(
        controller1_action1-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action10-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action11-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action12-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action2-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action3-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action4-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action5-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action6-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action7-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action8-d41d8cd98f00b204e9800998ecf8427e.css
        controller1_action9-d41d8cd98f00b204e9800998ecf8427e.css
        controller2_action1-d41d8cd98f00b204e9800998ecf8427e.css
        controller2_action2-d41d8cd98f00b204e9800998ecf8427e.css
        controller3_action1-d41d8cd98f00b204e9800998ecf8427e.css
      ).map { |file| "#{PACKAGER_TEST_ROOT}/assets/#{CSS_PATH}/#{file}" }

      Dir["#{PACKAGER_TEST_ROOT}/assets/#{CSS_PATH}/*.css"].should == expected
    end
  end
end