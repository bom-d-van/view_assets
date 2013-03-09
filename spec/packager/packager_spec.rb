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
      JsPackager.new.package
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
      CssPackager.new.package
    end
  end
end