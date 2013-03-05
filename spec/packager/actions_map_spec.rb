require File.expand_path('packager_helper.rb', File.dirname(__FILE__))

describe ActionsMap do
  before(:each) do
    PathInfo.any_instance.stub(:root).and_return(File.expand_path('fixtures/actions_map', File.dirname(__FILE__)))
  end
  
  describe JsActionsMap do
    it "retrieve all controller-actions map" do
      expected = {
        "controller1" => ["action1", "action10", "action11", "action2", "action3", "action4", "action5", "action6", "action7", "action8", "action9"],
        "controller2" => ["action1", "action2"],
        "controller3" => ["action1"]
      }
      
      JsActionsMap.new.retrieve.should == expected
    end
  end

  describe CssActionsMap do
    it "retrieve all controller-actions map" do
      expected = {
        "controller1" => ["action1", "action10", "action11", "action2", "action3", "action4", "action5", "action6", "action7", "action8", "action9"],
        "controller2" => ["action1", "action2"],
        "controller3" => ["action1"]
      }
      
      CssActionsMap.new.retrieve.should == expected
    end
  end
end