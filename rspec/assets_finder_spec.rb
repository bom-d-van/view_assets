require File.expand_path File.dirname(__FILE__) + '/rspec_helper'

describe AssetsFinder do
  let(:simple_af) { AssetsFinder.new('', '', '') }
  let(:empty_af) { AssetsFinder.new(FIXTURE_ROOT, '', '') }
  before(:each) do
    AssetsFinder.any_instance.stub(:asset_extension).and_return('js')
    AssetsFinder.any_instance.stub(:asset_type).and_return('js')
    AssetsFinder.any_instance.stub(:assets_path).and_return('javascripts')
  end
  
  describe 'path string manipulation' do
    it '#absolutely_pathize' do
      empty_af.send(:absolutely_pathize, 'path', 'file').should == "#{FIXTURE_ROOT}/path/file.js"
    end

    it '#unabsolutely_pathize' do
      empty_af.send(:unabsolutely_pathize, "#{FIXTURE_ROOT}/path/file.js").should == 'path/file.js'
    end
  end
  
  describe '#relatively_pathize' do
    it 'with filename extension' do
      simple_af.send(:relatively_pathize, 'dir', 'asset').should == 'dir/asset.js'
    end
    
    it 'without filename extension' do 
      simple_af.send(:relatively_pathize, 'dir', 'asset.js').should == 'dir/asset.js'
    end
  end
  
  it '#retrieve_app_assets' do
    simple_af.send(:retrieve_app_assets, 'asset1').should == 'app/assets/javascripts/asset1.js'
  end
  
  describe '#retrieve_lib_assets' do
    it 'one-file library' do
      af = AssetsFinder.new("#{FIXTURE_ROOT}/fixtures", '', '')
      libs = %w(lib2/others lib2/index lib3).map { |f| "lib/javascripts/#{f}.js" }
      af.send(:retrieve_lib_assets, 'lib1').should == libs
    end
    
    it 'indexing(multiple-file) library' do
      pending 'unimplemeted'
    end
    
    context 'other-library-dependent library' do
      it('one-file library dependency') { pending 'unimplemeted' }
      it('indexing library dependency') { pending 'unimplemeted' }
    end
    
    it 'vendor dependent library' do
      pending 'unimplemeted'
    end
    
    it 'self-loop dependency declaration' do
      pending 'unimplemeted'
    end
  end
  
  describe '#retrieve_assets' do
    it 'app assets only retrievement' do
      assumed_assets = %w(others others2 others3).map { |f| "app/assets/javascripts/#{f}.js" }
      simple_af.send(:retrieve_assets, "#{FIXTURE_ROOT}/simple.js").should == assumed_assets
    end
    
    it 'retrievement with end_of_parsing directive' do
      pending 'unimplemeted'
    end
  end
end