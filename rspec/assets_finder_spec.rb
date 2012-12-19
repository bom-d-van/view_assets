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
    af = AssetsFinder.new(FIXTURE_ROOT, 'controller1', 'action1')
    apps = %w(action2/others action1).map { |f| "app/javascripts/controller1/#{f}.js" }
    af.send(:retrieve_app_assets, 'action1').should == apps
  end
  
  # for lib dependency
  # FIXME convert this description of example group for "meta_retrieve" method
  describe '#retrieve_lib_assets' do
    context 'one-file library' do
      it 'has corresponding requiring sequence' do
        libs = %w(lib3 lib1).map { |f| "lib/javascripts/#{f}.js" }
        empty_af.send(:retrieve_lib_assets, 'lib1').should == libs
      end
      
      it 'has not corresponding requiring sequence' do
        libs = %w(lib1 lib3).map { |f| "lib/javascripts/#{f}.js" }
        empty_af.send(:retrieve_lib_assets, 'lib1').should_not == libs
      end
    end
    
    it 'indexing(multiple-file) library' do
      libs = %w(index others).map { |f| "lib/javascripts/lib2/#{f}.js" }
      empty_af.send(:retrieve_lib_assets, 'lib2').should == libs
    end
    
    it 'other-library-dependent library' do
      # it('one-file library dependency') { pending 'unimplemeted' }
      # it('indexing library dependency') { pending 'unimplemeted' }
      libs = %w(lib3 lib1 lib2/index lib2/others lib4/index).map { |f| "lib/javascripts/#{f}.js" }
      empty_af.send(:retrieve_lib_assets, 'lib4').should == libs
    end
  end

  it '#requrie_vendor_assets' do
    vendors = %w(vendor1 vendor2/index vendor2/others).map { |f| "vendor/javascripts/#{f}.js" }
    empty_af.send(:retrieve_vendor_assets, 'vendor2').should == vendors
  end
  
  it 'self-loop dependency declaration' do
    pending 'unimplemeted'
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