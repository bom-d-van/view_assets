require File.expand_path('./rspec_helper', File.dirname(__FILE__))
TEST_ROOT = "/to/my/app"

class Rails
  def self.root
    TEST_ROOT
  end
end

require 'view_assets'
include ViewAssets


describe PathInfo do
  let(:abs_path) { PathInfo.new("#{TEST_ROOT}/app/javascripts/file.js") }
  let(:rel_path) { PathInfo.new("app/javascripts/file.js") }
  
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
end