require File.expand_path File.dirname(__FILE__) + '/rspec_helper'

describe AssetsFinder do
  let(:empty_af) { AssetsFinder.new('', '', '') }
  let(:simple_af) { AssetsFinder.new(FIXTURE_ROOT, '', '') }
  let(:main_af) { AssetsFinder.new(FIXTURE_ROOT, 'main', '') }
  
  before(:each) do
    AssetsFinder.any_instance.stub(:asset_extension).and_return('js')
    AssetsFinder.any_instance.stub(:asset_type).and_return('js')
    AssetsFinder.any_instance.stub(:assets_path).and_return('javascripts')
  end
  
  describe 'path string manipulation' do
    it '#absolutely_pathize' do
      simple_af.send(:absolutely_pathize, 'path', 'file').should == "#{ FIXTURE_ROOT }/path/file.js"
    end

    it '#unabsolutely_pathize' do
      simple_af.send(:unabsolutely_pathize, "#{ FIXTURE_ROOT }/path/file.js").should == 'path/file.js'
    end
  end
  
  describe '#relatively_pathize' do
    it 'with filename extension' do
      empty_af.send(:relatively_pathize, 'dir', 'asset').should == 'dir/asset.js'
    end
    
    it 'without filename extension' do 
      empty_af.send(:relatively_pathize, 'dir', 'asset.js').should == 'dir/asset.js'
    end
  end
  
  context '#retrieve_app_asset' do
    it 'can retrieve asset of other actions in the same controller' do
      asset = "app/javascripts/main/multiple_files_action/others.js"
      
      main_af.send(:retrieve_app_asset, 'multiple_files_action/others').should == asset
    end
    
    it 'can retrieve asset from a different controller' do
      asset = "app/javascripts/another_controller/another_multiple_files_action/others.js"
      
      main_af.send(:retrieve_app_asset, '/another_controller/another_multiple_files_action/others.js').should == asset
    end
  end
  
  # for lib dependency
  # FIXME convert this description of example group for "meta_retrieve" method
  describe '#retrieve_lib_assets' do
    context 'one-file library' do
      it 'has corresponding requiring sequence' do
        pending 'need to be corrected'
        libs = %w(lib3 lib1).map { |f| "lib/javascripts/#{ f }.js" }
        simple_af.send(:retrieve_lib_assets, 'lib1').should == libs
      end
      
      it 'has not corresponding requiring sequence' do
        pending 'need to be corrected'
        libs = %w(lib1 lib3).map { |f| "lib/javascripts/#{ f }.js" }
        simple_af.send(:retrieve_lib_assets, 'lib1').should_not == libs
      end
    end
    
    it 'indexing(multiple-file) library' do
      pending 'need to be corrected'
      libs = %w(index others).map { |f| "lib/javascripts/lib2/#{ f }.js" }
      simple_af.send(:retrieve_lib_assets, 'lib2').should == libs
    end
    
    it 'other-library-dependent library' do
      # it('one-file library dependency') { pending 'unimplemeted' }
      # it('indexing library dependency') { pending 'unimplemeted' }
      pending 'need to be corrected'
      libs = %w(lib3 lib1 lib2/index lib2/others lib4/index).map { |f| "lib/javascripts/#{ f }.js" }
      simple_af.send(:retrieve_lib_assets, 'lib4').should == libs
    end
  end

  it '#requrie_vendor_assets' do
    pending 'consider whether is this example still necessary?'
    # vendors = %w(vendor1 vendor2/index vendor2/others).map { |f| "vendor/javascripts/#{ f }.js" }
    # simple_af.send(:retrieve_vendor_assets, 'vendor2').should == vendors
  end
  
  it 'self-loop dependency declaration' do
    pending 'unimplemeted'
  end
  
  describe '#retrieve_assets' do
    context 'when retrieving app assets from actions' do
      it 'in the same controller' do
        required_assets = ["app/javascripts/main/multiple_files_action/others.js"]
        app_manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/retrieving_from_another_action.js"
        
        main_af.send(:retrieve_assets, app_manifest).should == required_assets
      end
      
      it 'from a different controller' do
        required_assets = ["app/javascripts/another_controller/another_multiple_files_action/others.js"]
        app_manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/retrieving_from_another_controller.js"
        
        main_af.send(:retrieve_assets, app_manifest).should == required_assets
      end
    end
    
    context 'when retrieving vendor assets' do
      it 'can retrieve a standalone vendor' do
        required_assets = ["vendor/javascripts/simple.js"]
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/vendor_retrival.js"
        
        main_af.send(:retrieve_assets, manifest).should == required_assets
      end
      
      # TODO think about the importance of order during the requiring.
      it 'can retrieve vendor that contains multiple files' do
        # If I write "%w(others index)", this example will fail
        required_assets = %w(index others).map { |f| "vendor/javascripts/multiple_files/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/multiple_files_vendor_retrival.js"
        
        main_af.send(:retrieve_assets, manifest).should == required_assets
      end
      
      it 'can retrieve vendor that depends on other vendor' do
        files = %w(multiple_files/index multiple_files/others simple nested)
        required_assets = files.map { |f| "vendor/javascripts/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/nested_vendor.js"
        
        main_af.send(:retrieve_assets, manifest).should == required_assets
      end
    end
    
    context 'when retrieving lib assets' do
      it 'can retrieve a standalone lib' do
        required_assets = ["lib/javascripts/simple.js"]
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/simple_lib.js"
        
        main_af.send(:retrieve_assets, manifest).should == required_assets
      end
      
      it 'can retrieve a multiple-files lib' do
        # If I write "%w(others index)", this example will fail
        pending 'make a shared example'
        required_assets = %w(index others).map { |f| "lib/javascripts/multiple_files/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/multiple_files_vendor_retrival.js"
        
        main_af.send(:retrieve_assets, manifest).should == required_assets
      end
      
      it 'can retrieve lib that depends on a simple vendor' do
        pending 'need to test vendor first'
      end
      
      it 'can retrieve lib that depends on a multiple-file vendor' do
        pending 'need to test vendor first'
      end
      
      it 'can retrieve lib that depends on a nested vendor' do
        pending 'need to test vendor first'
      end
    end
    
    it 'retrievement with end_of_parsing directive' do
      pending 'unimplemeted'
    end
  end
  
  it 'duplicated requiring' do
    pending 'to realize after most common functions of this plugin work'
  end
end