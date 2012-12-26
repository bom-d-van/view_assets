require File.expand_path File.dirname(__FILE__) + '/rspec_helper'

describe AssetsFinder do
  let(:empty_af) { AssetsFinder.new('', '', '') }
  let(:simple_af) { AssetsFinder.new(FIXTURE_ROOT, '', '') }
  let(:main_af) { AssetsFinder.new(FIXTURE_ROOT, 'main', '') }
  let(:action_test_af) { AssetsFinder.new(FIXTURE_ROOT, 'main', 'action_test') }
  let(:action_test_assets) { %w(vendor/javascripts/simple.js lib/javascripts/simple.js app/javascripts/another_controller/action1.js app/javascripts/main/action_test.js) }
  
  before(:each) do
    AssetsFinder.any_instance.stub(:asset_extension).and_return('js')
    AssetsFinder.any_instance.stub(:asset_type).and_return('js')
    AssetsFinder.any_instance.stub(:assets_path).and_return('javascripts')
  end
  
  describe 'path string manipulation' do
    it '#absolutely_pathize' do
      simple_af.send(:absolutely_pathize, 'path/file').should == "#{ FIXTURE_ROOT }/path/file.js"
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
  
  describe '#retrieve_app_asset' do
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
  
  describe '#retrieve_assets_from' do
    context 'when retrieving app assets from actions' do
      it 'in the same controller' do
        required_assets = ["app/javascripts/main/multiple_files_action/others.js"]
        app_manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/retrieving_from_another_action.js"
        
        main_af.send(:retrieve_assets_from, app_manifest).should == required_assets
      end
      
      it 'from a different controller' do
        required_assets = ["app/javascripts/another_controller/another_multiple_files_action/others.js"]
        app_manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/retrieving_from_another_controller.js"
        
        main_af.send(:retrieve_assets_from, app_manifest).should == required_assets
      end
    end
    
    shared_examples 'retrievable' do |type|
      it "can retrieve a standalone #{ type }" do
        required_assets = ["#{ type }/javascripts/simple.js"]
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/simple_#{ type }.js"
        
        main_af.send(:retrieve_assets_from, manifest).should == required_assets
      end
    
      # # TODO think about the importance of order during the requiring.
      # # If I write "%w(others index)", this example will fail
      it "can retrieve a multiple-files #{ type }" do
        required_assets = %w(index others).map { |f| "#{ type }/javascripts/multiple_files/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/multiple_files_#{ type }.js"
        
        main_af.send(:retrieve_assets_from, manifest).should == required_assets
      end
      
      it "can retrieve vendor that depends on other #{ type }" do
        required_assets = %w(multiple_files/index multiple_files/others simple nested).map { |f| "#{ type }/javascripts/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/nested_#{ type }.js"
        
        main_af.send(:retrieve_assets_from, manifest).should == required_assets
      end
      
      it "can retrieve deeply nested #{ type }" do
        required_assets = %w(multiple_files/index multiple_files/others simple nested complicated_nested).map { |f| "#{ type }/javascripts/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/complicated_nested_#{ type }.js"
        
        main_af.send(:retrieve_assets_from, manifest).should == required_assets
      end
      
      it "can retrieve multiple-files and deeply-nested #{ type }" do
        required_assets = %w(multiple_files/index multiple_files/others simple nested complicated_nested  to_be_required multiple_files_with_nested/index multiple_files_with_nested/others).map { |f| "#{ type }/javascripts/#{ f }.js" }
        manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/multiple_files_with_nested_#{ type }.js"
        
        main_af.send(:retrieve_assets_from, manifest).should == required_assets
      end
    end
    
    context 'when retrieving vendor assets' do
      it_should_behave_like 'retrievable', 'vendor'
    end
    
    context 'when retrieving lib assets' do
      it_should_behave_like 'retrievable', 'lib'
      
      context 'when depending on a vendor' do
        it 'can depends on a simple vendor' do
          required_assets = %w(vendor/javascripts/simple.js lib/javascripts/with_a_simple_vendor.js)
          manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/lib_with_a_simple_vendor.js"

          main_af.send(:retrieve_assets_from, manifest).should == required_assets
        end

        it 'can depends on a multiple-file vendor' do
          required_assets = %w(vendor/javascripts/multiple_files/index.js vendor/javascripts/multiple_files/others.js lib/javascripts/with_a_multiple_files_vendor.js)
          manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/lib_with_a_multiple_files_vendor.js"

          main_af.send(:retrieve_assets_from, manifest).should == required_assets
        end

        # TODO cosider whether this example is really necessary
        # it 'can depends on a complicated and nested vendor' do
        #   pending 'something else'
        #   required_assets = %w(vendor/javascripts/multiple_files/index.js vendor/javascripts/multiple_files/others.js lib/javascripts/with_a_multiple_files_vendor.js)
        #   manifest = "#{ FIXTURE_ROOT }/app/javascripts/main/lib_with_a_multiple_files_vendor.js"
        # 
        #   main_af.send(:retrieve_assets_from, manifest).should == required_assets
        # end
      end
    end
    
    it 'retrievement with end_of_parsing directive' do
      pending 'unimplemeted'
    end
  end
  
  it 'duplicated requiring' do
    pending 'to realize after most common functions of this plugin work'
  end
  
  describe '#action_assets' do
    context 'when retrieving assets' do
      let(:action_assets) { action_test_af.action_assets }
      it 'can retrieve required assets' do
        action_assets.should == action_test_assets
      end

      it 'require action manifest as the last element' do
        action_assets.last.should == 'app/javascripts/main/action_test.js'
      end
    end
    
    it 'should cache the assets after the first time of retrieval' do
      action_test_af.action_assets.object_id.should == action_test_af.action_assets.object_id
    end
  end
  
  describe '#controller_assets' do
    context 'when retrieving assets' do
      it 'will use application.js as default controller asset setup' do
        required_assets = %w(lib/javascripts/simple.js vendor/javascripts/simple.js app/javascripts/application.js)
        
        main_af.controller_assets.should == required_assets
      end
      
      it 'will use specific controller asset setup as there is one' do
        required_assets = %w(vendor/javascripts/to_be_required.js lib/javascripts/to_be_required.js app/javascripts/another_controller/another_controller.js)
        af = AssetsFinder.new(FIXTURE_ROOT, 'another_controller', '')
        
        af.controller_assets.should == required_assets
      end
    end
  end
  
  describe '#all_assets' do
    it 'retrieve controller assets before action assets' do
      af = AssetsFinder.new(FIXTURE_ROOT, 'main', 'all_assets')
      required_assets = %w(lib/javascripts/simple.js vendor/javascripts/simple.js app/javascripts/application.js app/javascripts/main/multiple_files_action/others.js app/javascripts/main/all_assets.js)
      
      af.all_assets.should == required_assets
    end
    
    it 'pluck all the repetitive assets' do
      af = AssetsFinder.new(FIXTURE_ROOT, 'main', 'all_assets_with_repetitive_requiring')
      required_assets = %w(lib/javascripts/simple.js vendor/javascripts/simple.js app/javascripts/application.js app/javascripts/main/all_assets_with_repetitive_requiring.js)
      
      af.all_assets.should == required_assets
    end
  end
end