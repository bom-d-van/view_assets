require File.expand_path('./rspec_helper', File.dirname(__FILE__))
require 'view_assets/action_view'

describe ActionViewHelpers do
  class Dummy
    include ActionViewHelpers
  end
  AVH_TEST_ROOT = File.expand_path('./fixtures/action_view', File.dirname(__FILE__))

  describe "#retrieve_assets" do
    context "Production Mode" do
      let(:va) { Dummy.new }
      before(:each) do
        Rails.stub(:public_path).and_return(AVH_TEST_ROOT)
        Rails.stub_chain('env.production?').and_return(:true)
      end

      it "retrieve specific controller and action" do
        va.should_receive(:raw).with(
          ViewAssets.tag(:css, '/assets/stylesheets/controller1_action1-d41d8cd98f00b204e9800998ecf8427e.css')
        ).ordered
        va.should_receive(:raw).with(
          ViewAssets.tag(:js, '/assets/javascripts/controller1_action1-d41d8cd98f00b204e9800998ecf8427e.js')
        ).ordered

        va.retrieve_assets('controller1', 'action1')
      end

      it "retrieve controller assets when action assets is nonexistent" do
        va.should_receive(:raw).with(
          ViewAssets.tag(:css, '/assets/stylesheets/controller3-d41d8cd98f00b204e9800998ecf8427e.css')
        ).ordered
        va.should_receive(:raw).with(
          ViewAssets.tag(:js, '/assets/javascripts/controller3-d41d8cd98f00b204e9800998ecf8427e.js')
        ).ordered

        va.retrieve_assets('controller3', 'action3')
      end

      it "retrieve application assets when controller and action assets are both nonexistent" do
        va.should_receive(:raw).with(
          ViewAssets.tag(:css, '/assets/stylesheets/application-d41d8cd98f00b204e9800998ecf8427e.css')
        ).ordered
        va.should_receive(:raw).with(
          ViewAssets.tag(:js, '/assets/javascripts/application-d41d8cd98f00b204e9800998ecf8427e.js')
        ).ordered

        va.retrieve_assets('controller2', 'action1')
      end
    end
  end
end