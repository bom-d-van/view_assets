require File.expand_path('./finder_spec_helper', File.dirname(__FILE__))

describe JsFinder do
  let(:finder) { JsFinder.new }
  let(:root) { File.dirname(__FILE__) + '/fixtures' }
  
  before(:each) do
    # any_instance can't support Parent class stubbing,
    # that means Finder.any_instance.stub(:root).and_return(root) will go wrong
    JsFinder.any_instance.stub(:root).and_return(root)
    PathInfo.any_instance.stub(:root).and_return(root)
  end
  
  describe "#retrieve" do
    context "straight-forward requirements" do
      it "using default application.js" do
        result = finder.retrieve({ :controller => 'controller1', :action => 'action1' })
        expected = %w(
          vendor/javascripts/vendor1.js 
          lib/javascripts/lib1.js 
          app/javascripts/application.js 
          lib/javascripts/lib2.js 
          app/javascripts/controller1/action1.js
        )
        
        result.should == expected
      end
      
      it "using specific controller.js" do
        result = finder.retrieve({ :controller => 'controller2', :action => 'action1' })
        expected = %w(
          vendor/javascripts/vendor1.js
          app/javascripts/controller2/controller2.js
          lib/javascripts/lib1.js
          app/javascripts/controller2/action1.js
        )
        
        result.should == expected
      end
      
      it "automatically requiring files in indexed requirements" do
        result = finder.retrieve({ :controller => 'controller1', :action => 'action2' })
        expected = %w(
          vendor/javascripts/vendor1.js 
          lib/javascripts/lib1.js 
          app/javascripts/application.js 
          app/javascripts/controller1/action2/others.js 
          app/javascripts/controller1/action2/others2.js
        )
        
        result.should == expected
      end
      
      it "using index as manifest in indexed requirements" do
        result = finder.retrieve({ :controller => 'controller1', :action => 'action3' })
        expected = %w(
          vendor/javascripts/vendor1.js 
          lib/javascripts/lib1.js 
          app/javascripts/application.js 
          vendor/javascripts/vendor2.js
          lib/javascripts/lib2.js
          app/javascripts/controller1/action3/index.js 
          app/javascripts/controller1/action3/others.js
        )
        
        result.should == expected
      end
      
      it "automatically requiring deeply-nested files in indexed requirements" do
        result = finder.retrieve({ :controller => 'controller1', :action => 'action4' })
        expected = %w(
          vendor/javascripts/vendor1.js 
          lib/javascripts/lib1.js 
          app/javascripts/application.js 
          vendor/javascripts/vendor2.js
          lib/javascripts/lib2.js
          app/javascripts/controller1/action4/asset/asset/file.js
          app/javascripts/controller1/action4/asset/file.js
          app/javascripts/controller1/action4/index.js 
          app/javascripts/controller1/action4/others.js
        )
        
        result.should == expected
      end
    end
  end
  
  context "when requirements are complicating" do
    it "retrieve nested dependences" do
      result = finder.retrieve({ :controller => 'controller1', :action => 'action5' })
      expected = %w(
        vendor/javascripts/vendor1.js
        lib/javascripts/lib1.js
        app/javascripts/application.js
        vendor/javascripts/vendor3.js
        vendor/javascripts/vendor4.js
        lib/javascripts/lib4.js
        lib/javascripts/lib3.js
        app/javascripts/controller1/action5.js
      )
        
      result.should == expected
    end
    
    it "retrieve multiple-files libs and vendors" do
      result = finder.retrieve({ :controller => 'controller1', :action => 'action6' })
      expected = %w(
        vendor/javascripts/vendor1.js
        lib/javascripts/lib1.js
        app/javascripts/application.js
        lib/javascripts/lib5/file1.js
        lib/javascripts/lib5/file2.js
        vendor/javascripts/vendor5/file1.js
        vendor/javascripts/vendor5/file2.js
        app/javascripts/controller1/action6/file1.js
        app/javascripts/controller1/action6/file2.js
        app/javascripts/controller1/action6/index.js
      )
        
      result.should == expected
    end
    
    it "retrieve indexed libs and vendors" do
      result = finder.retrieve({ :controller => 'controller1', :action => 'action7' })
      expected = %w(
        vendor/javascripts/vendor1.js
        lib/javascripts/lib1.js
        app/javascripts/application.js
        vendor/javascripts/vendor5/file1.js
        vendor/javascripts/vendor5/file2.js
        vendor/javascripts/vendor6/file1.js
        vendor/javascripts/vendor6/file2.js
        vendor/javascripts/vendor6/index.js
        lib/javascripts/lib5/file1.js
        lib/javascripts/lib5/file2.js
        lib/javascripts/lib6/file1.js
        lib/javascripts/lib6/file2.js
        lib/javascripts/lib6/index.js
        app/javascripts/controller1/action7.js
      )
      
      result.should == expected
    end
    
    it "avoid end-less retrieving for closed-loop requirements" do
      
    end
    
    it "support multiple requiring directives" do
      pending
    end
  end
end