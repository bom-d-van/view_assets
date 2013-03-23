require File.expand_path('./packager_helper', File.dirname(__FILE__))

PACKAGER_TEST_ROOT = "#{File.dirname(__FILE__)}/fixtures/packager"

include ViewAssets::Finder

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
        application-d41d8cd98f00b204e9800998ecf8427e.js
        controller1-d41d8cd98f00b204e9800998ecf8427e.js
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
        controller2-d41d8cd98f00b204e9800998ecf8427e.js
        controller2_action1-d41d8cd98f00b204e9800998ecf8427e.js
        controller2_action2-d41d8cd98f00b204e9800998ecf8427e.js
        controller3-d41d8cd98f00b204e9800998ecf8427e.js
        controller3_action1-d41d8cd98f00b204e9800998ecf8427e.js
      ).map { |file| "#{PACKAGER_TEST_ROOT}/assets/#{JS_PATH}/#{file}" }

      Dir["#{PACKAGER_TEST_ROOT}/assets/#{JS_PATH}/*.js"].should == expected
    end

    context "using other compressor" do
      let(:jspr) { JsPackager.new }
      it "support closure-compressor" do
        jspr.should_receive(:compress).with('google-closure', kind_of(String)).any_number_of_times.and_return("")

        jspr.package({}, { :compress_engine => 'google-closure' })
      end

      it "support uglifier" do
        jspr.should_receive(:compress).with('uglifier', kind_of(String)).any_number_of_times.and_return("")

        jspr.package({}, { :compress_engine => 'uglifier' })
      end

      it "support custom compiler" do
        mycompiler = double('my compiler')
        mycompiler.stub(:compress).and_return('')
        jspr.compressor.register('my-compiler', mycompiler)

        jspr.should_receive(:compress).with('my-compiler', kind_of(String)).any_number_of_times.and_return('')

        jspr.package({}, { :compress_engine  => 'my-compiler' })
      end

      it { expect { jspr.package({}, { :compress_engine => 'non-exist compiler' }) }.to raise_error(Error) }
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
        application-d41d8cd98f00b204e9800998ecf8427e.css
        controller1-d41d8cd98f00b204e9800998ecf8427e.css
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
        controller2-d41d8cd98f00b204e9800998ecf8427e.css
        controller2_action1-d41d8cd98f00b204e9800998ecf8427e.css
        controller2_action2-d41d8cd98f00b204e9800998ecf8427e.css
        controller3-d41d8cd98f00b204e9800998ecf8427e.css
        controller3_action1-d41d8cd98f00b204e9800998ecf8427e.css
      ).map { |file| "#{PACKAGER_TEST_ROOT}/assets/#{CSS_PATH}/#{file}" }

      Dir["#{PACKAGER_TEST_ROOT}/assets/#{CSS_PATH}/*.css"].should == expected
    end

    context "using other compressor" do
      let(:csspr) { CssPackager.new }

      it "support custom compiler" do
        mycompiler = double('my compiler')
        mycompiler.stub(:compress).and_return('')
        csspr.compressor.register('my-compiler', mycompiler)

        csspr.should_receive(:compress).with('my-compiler', kind_of(String)).any_number_of_times.and_return('')

        csspr.package({}, { :compress_engine  => 'my-compiler' })
      end

      it { expect { csspr.package({}, { :compress_engine => 'non-exist compiler' }) }.to raise_error(Error) }
    end
  end
end