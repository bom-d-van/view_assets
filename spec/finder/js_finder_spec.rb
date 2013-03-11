require File.expand_path('./finder_spec_helper', File.dirname(__FILE__))

describe JsFinder do
  let(:finder) { JsFinder.new }
  let(:root) { File.dirname(__FILE__) + '/fixtures' }

  before(:each) do
    # any_instance can't support Parent class stubbing,
    # that means Finder.any_instance.stub(:root).and_return(root) will go wrong
    JsFinder.any_instance.stub(:root).and_return(root)
    PathInfo.any_instance.stub(:root).and_return(root)
  end

  include_examples "finder", JS_PATH, JS_EXT, ViewAssets.method(:tag)
end