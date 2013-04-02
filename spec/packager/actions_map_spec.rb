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

      map = JsActionsMap.new.retrieve
      map["controller1"].should =~ expected["controller1"]
      map["controller2"].should =~ expected["controller2"]
      map["controller3"].should =~ expected["controller3"]
    end
  end

  describe CssActionsMap do
    it "retrieve all controller-actions map" do
      expected = {
        "controller1" => ["action1", "action10", "action11", "action2", "action3", "action4", "action5", "action6", "action7", "action8", "action9"],
        "controller2" => ["action1", "action2"],
        "controller3" => ["action1"]
      }

      map = CssActionsMap.new.retrieve
      map["controller1"].should =~ expected["controller1"]
      map["controller2"].should =~ expected["controller2"]
      map["controller3"].should =~ expected["controller3"]
    end
  end
end