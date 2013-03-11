require File.expand_path('./finder_spec_helper', File.dirname(__FILE__))

describe CssFinder do
  let(:finder) { CssFinder.new }
  let(:root) { File.dirname(__FILE__) + '/fixtures' }

  before(:each) do
    # any_instance can't support Parent class stubbing,
    # that means Finder.any_instance.stub(:root).and_return(root) will go wrong
    CssFinder.any_instance.stub(:root).and_return(root)
    PathInfo.any_instance.stub(:root).and_return(root)
  end

  include_examples "finder", CSS_PATH, CSS_EXT, ViewAssets.method(:tag)
end