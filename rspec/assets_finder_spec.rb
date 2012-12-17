require File.expand_path File.dirname(__FILE__) + '/rspec_helper'

describe AssetsFinder do
  before(:each) do
    # AssetsFinder.any_instance.stub(:each_line) do |&directive_handler|
    #   [
    #     '//= require_vendor vendor1, vendor2',
    #     ' *= require_lib lib1, lib2',
    #     '/*= require app1, app2 */'
    #   ].map do |l|
    #     directive_handler.call l
    #   end
    # end
    # @assets_finder = AssetsFinder.new('root', 'controller', 'action')
  end
  
  it 'should retrieve all paths' do
    # assets_finder.retrieve_assets('manifest').should == 
  end
end