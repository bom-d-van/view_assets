require File.expand_path('./rspec_helper', File.dirname(__FILE__))

TEST_ROOT = "path/to/my/app"

describe PathInfo do
  before(:each) { PathInfo.any_instance.stub(:root).and_return(TEST_ROOT) }

  let(:abs_path) { PathInfo.new("#{TEST_ROOT}/app/javascripts/file.js") }
  let(:rel_path) { PathInfo.new("app/javascripts/file.js") }

  describe "#abs?" do
    it { abs_path.abs?.should == true }
    it { rel_path.abs?.should == false }
  end

  describe "#abs" do
      it { abs_path.abs.to_s.should == "#{TEST_ROOT}/app/javascripts/file.js" }
      it { rel_path.abs.to_s.should == "#{TEST_ROOT}/app/javascripts/file.js" }
  end

  describe "#abs!" do
    it do
      abs_path.abs!
      abs_path.to_s.should == "#{TEST_ROOT}/app/javascripts/file.js"
    end

    it do
      rel_path.abs!
      rel_path.to_s.should == "#{TEST_ROOT}/app/javascripts/file.js"
    end
  end

  describe "#rel" do
    it { abs_path.rel.to_s.should == "app/javascripts/file.js" }
    it { rel_path.rel.to_s.should == "app/javascripts/file.js" }
  end

  describe "#rel!" do
    it do
      abs_path.rel!
      abs_path.to_s.should == "app/javascripts/file.js"
    end

    it do
      rel_path.rel!
      rel_path.to_s.should == "app/javascripts/file.js"
    end
  end

  describe "category" do
    it "belongs to lib category" do
      PathInfo.new("lib/javascripts/something.js").lib? == true
      PathInfo.new("lib/stylesheets/something.js").lib? == true
    end

    it "belongs to vendor category" do
      PathInfo.new("vendor/javascripts/something.js").lib? == true
      PathInfo.new("vendor/stylesheets/something.js").lib? == true
    end

    it "belongs to app category" do
      PathInfo.new("app/javascripts/something.js").lib? == true
      PathInfo.new("app/stylesheets/something.js").lib? == true
    end
  end

  describe "#depth" do
    it "return correct info" do
      PathInfo.new('lib/javascripts/file.js').depth.should == 0
    end

    it "ignore absolute path" do
      PathInfo.new(TEST_ROOT + '/lib/javascripts/file.js').depth.should == 0
    end

    it "treat app controller-action structure like vendor and lib" do
      PathInfo.new('app/javascripts/controller/action/file.js').depth.should == 2
    end
  end
end