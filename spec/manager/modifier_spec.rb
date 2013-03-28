require File.expand_path("../rspec_helper", File.dirname(__FILE__))
require "view_assets/manager/manager"
include ViewAssets::Manager

describe 'JsModifier' do
  let(:modifier) { JsModifier.new }

  describe "#modify" do
    before(:each) do
      Rails.stub(:public_path).and_return("#{File.expand_path("fixtures/map", File.dirname(__FILE__))}")
    end

    it "update requirement blocks" do
      content = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vivamus vitae risus vitae lorem iaculis placerat. Aliquam sit amet felis. Etiam congue. Donec risus risus, pretium ac, tincidunt eu, tempor eu, quam. Morbi blandit mollis magna. Suspendisse eu tortor. Donec vitae felis nec ligula blandit rhoncus. Ut a pede ac neque mattis facilisis. Nulla nunc ipsum, sodales vitae, hendrerit non, imperdiet ac, ante. Morbi sit amet mi. Ut magna. Curabitur id est. Nulla velit. Sed consectetuer sodales justo. Aliquam dictum gravida libero. Sed eu turpis. Nunc id lorem. Aenean consequat tempor mi. Phasellus in neque. Nunc fermentum convallis ligula."
      File.open('fake-asset', 'w') do |file|
        file << "//= require_vendor vendor1\n"
        file << "//= require_lib lib1\n"

        file << content
      end
      block = "//= require_vendor vendor2\n"
      block += "//= require_lib lib2\n"

      modifier.modify('fake-asset', block)

      File.new('fake-asset').read.should == block + content

      FileUtils.remove('fake-asset')
    end
  end

  describe "#update" do
    modifer_fixtures_path = File.expand_path("fixtures/modifier", File.dirname(__FILE__))
    back_up_modifer_fixtures_path = "#{modifer_fixtures_path}.backup"
    before(:all) do
      FileUtils.cp_r(modifer_fixtures_path, back_up_modifer_fixtures_path)
    end

    after(:all) do
      FileUtils.rm_rf(modifer_fixtures_path)
      FileUtils.mv(back_up_modifer_fixtures_path, modifer_fixtures_path)
    end

    before(:each) do
      Rails.stub(:public_path).and_return(modifer_fixtures_path)

      FileUtils.rm_rf(modifer_fixtures_path)
      FileUtils.cp_r(back_up_modifer_fixtures_path, modifer_fixtures_path)
    end

    context "update lib index" do
      it "update index file name" do
        modifier.update('lib/javascripts/lib2', 'lib/javascripts/lib2-1')
        modifier.update_map

        modifier.map[:lib].key?('lib/javascripts/lib2-1').should == true
        modifier.map[:lib].key?('lib/javascripts/lib2').should == false
      end

      it "update requirements" do

      end
    end

    # it "update vendor index" do
    #
    # end
    #
    # it "update app index" do
    #
    # end
  end
end