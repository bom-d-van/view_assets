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

  describe "#retrieve" do
    context "straight-forward requirements" do
      it "using default application.css" do
        result = finder.retrieve('controller1', 'action1')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          lib/stylesheets/lib2.css
          app/stylesheets/controller1/action1.css
        )

        result.should == expected
      end

      it "using specific controller.css" do
        result = finder.retrieve('controller2', 'action1')
        expected = %w(
          vendor/stylesheets/vendor1.css
          app/stylesheets/controller2/controller2.css
          lib/stylesheets/lib1.css
          app/stylesheets/controller2/action1.css
        )

        result.should == expected
      end

      it "automatically requiring files in indexed requirements" do
        result = finder.retrieve('controller1', 'action2')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          app/stylesheets/controller1/action2/others.css
          app/stylesheets/controller1/action2/others2.css
        )

        result.should == expected
      end

      it "using index as manifest in indexed requirements" do
        result = finder.retrieve('controller1', 'action3')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          vendor/stylesheets/vendor2.css
          lib/stylesheets/lib2.css
          app/stylesheets/controller1/action3/index.css
          app/stylesheets/controller1/action3/others.css
        )

        result.should == expected
      end

      it "automatically requiring deeply-nested files in indexed requirements" do
        result = finder.retrieve('controller1', 'action4')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          vendor/stylesheets/vendor2.css
          lib/stylesheets/lib2.css
          app/stylesheets/controller1/action4/asset/asset/file.css
          app/stylesheets/controller1/action4/asset/file.css
          app/stylesheets/controller1/action4/index.css
          app/stylesheets/controller1/action4/others.css
        )

        result.should == expected
      end
    end

    context "when requirements are complicating" do
      it "retrieves nested dependences" do
        result = finder.retrieve('controller1', 'action5')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          vendor/stylesheets/vendor3.css
          vendor/stylesheets/vendor4.css
          lib/stylesheets/lib4.css
          lib/stylesheets/lib3.css
          app/stylesheets/controller1/action5.css
        )

        result.should == expected
      end

      it "retrieves multiple-files libs and vendors" do
        result = finder.retrieve('controller1', 'action6')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          lib/stylesheets/lib5/file1.css
          lib/stylesheets/lib5/file2.css
          vendor/stylesheets/vendor5/file1.css
          vendor/stylesheets/vendor5/file2.css
          app/stylesheets/controller1/action6/file1.css
          app/stylesheets/controller1/action6/file2.css
          app/stylesheets/controller1/action6/index.css
        )

        result.should == expected
      end

      it "retrieves indexed libs and vendors" do
        result = finder.retrieve('controller1', 'action7')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          vendor/stylesheets/vendor5/file1.css
          vendor/stylesheets/vendor5/file2.css
          vendor/stylesheets/vendor6/file1.css
          vendor/stylesheets/vendor6/file2.css
          vendor/stylesheets/vendor6/index.css
          lib/stylesheets/lib5/file1.css
          lib/stylesheets/lib5/file2.css
          lib/stylesheets/lib6/file1.css
          lib/stylesheets/lib6/file2.css
          lib/stylesheets/lib6/index.css
          app/stylesheets/controller1/action7.css
        )

        result.should == expected
      end

      it "avoids end-less retrieving for closed-loop requirements" do
        result = finder.retrieve('controller1', 'action8')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          lib/stylesheets/lib8.css
          lib/stylesheets/lib7.css
          app/stylesheets/controller1/action8.css
        )

        result.should == expected
      end

      it "supports multiple requiring directives" do
        result = finder.retrieve('controller3', 'action1')
        expected = %w(
          vendor/stylesheets/vendor7.css
          vendor/stylesheets/vendor8.css
          lib/stylesheets/lib10.css
          vendor/stylesheets/vendor10.css
          app/stylesheets/controller3/controller3.css
          vendor/stylesheets/vendor9.css
          lib/stylesheets/lib9.css
          lib/stylesheets/lib11.css
          app/stylesheets/controller3/action1.css
        )

        result.should == expected
      end

      it "retrieves assets from another action" do
        result = finder.retrieve('controller1', 'action9')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          app/stylesheets/controller1/action10/file1.css
          app/stylesheets/controller1/action10/file2.css
          app/stylesheets/controller1/action9.css
        )

        result.should == expected
      end

      it "retrieves assets fron another controller" do
        result = finder.retrieve('controller1', 'action11')
        expected = %w(
          vendor/stylesheets/vendor1.css
          lib/stylesheets/lib1.css
          app/stylesheets/application.css
          app/stylesheets//controller2/action2/file1.css
          app/stylesheets//controller2/action2/file2.css
          app/stylesheets/controller1/action11/index.css
        )

        result.should == expected
      end
    end
  end

  it "support :full options" do
    result = finder.retrieve('controller1', 'action12', :full => true)
    expected = %w(
      /Users/bom_d_van/Code/ruby/view_assets/spec/finder/fixtures/vendor/stylesheets/vendor1.css
      /Users/bom_d_van/Code/ruby/view_assets/spec/finder/fixtures/lib/stylesheets/lib1.css
      /Users/bom_d_van/Code/ruby/view_assets/spec/finder/fixtures/app/stylesheets/application.css
      /Users/bom_d_van/Code/ruby/view_assets/spec/finder/fixtures/vendor/stylesheets/vendor11.css
      /Users/bom_d_van/Code/ruby/view_assets/spec/finder/fixtures/lib/stylesheets/lib12.css
      /Users/bom_d_van/Code/ruby/view_assets/spec/finder/fixtures/app/stylesheets/controller1/action12.css
    )

    result.should == expected
  end

  it "support :tagged options" do
    result = finder.retrieve('controller1', 'action12', :tagged => true)
    expected = [
      "<link href='/vendor/stylesheets/vendor1.css' media='screen' rel='stylesheet' />",
      "<link href='/lib/stylesheets/lib1.css' media='screen' rel='stylesheet' />",
      "<link href='/app/stylesheets/application.css' media='screen' rel='stylesheet' />",
      "<link href='/vendor/stylesheets/vendor11.css' media='screen' rel='stylesheet' />",
      "<link href='/lib/stylesheets/lib12.css' media='screen' rel='stylesheet' />",
      "<link href='/app/stylesheets/controller1/action12.css' media='screen' rel='stylesheet' />"
    ]

    result.should == expected
  end

  it "return tagged assets with rel path even :full options is true" do
    result = finder.retrieve('controller1', 'action12', :tagged => true, :full => true)
    expected = [
      "<link href='/vendor/stylesheets/vendor1.css' media='screen' rel='stylesheet' />",
      "<link href='/lib/stylesheets/lib1.css' media='screen' rel='stylesheet' />",
      "<link href='/app/stylesheets/application.css' media='screen' rel='stylesheet' />",
      "<link href='/vendor/stylesheets/vendor11.css' media='screen' rel='stylesheet' />",
      "<link href='/lib/stylesheets/lib12.css' media='screen' rel='stylesheet' />",
      "<link href='/app/stylesheets/controller1/action12.css' media='screen' rel='stylesheet' />"
    ]

    result.should == expected
  end
end