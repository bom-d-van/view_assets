require File.expand_path('./rspec_helper', File.dirname(__FILE__))

# shared_examples 'path' do |dir, extension|
describe PathInfo do
  let(:abs_path) { PathInfo.new("#{FIXTURE_ROOT}/app/javascripts/file.js") }
  let(:rel_path) { PathInfo.new("app/javascripts/file.js") }
  
  describe "#abs" do
      it { abs_path.abs.should == "#{FIXTURE_ROOT}/app/javascripts/file.js" }
      it { rel_path.abs.should == "#{FIXTURE_ROOT}/app/javascripts/file.js" }
  end
  
  describe "#abs!" do
    it do
      abs_path.abs!
      abs_path.should == "#{FIXTURE_ROOT}/app/javascripts/file.js"
    end

    it do
      rel_path.abs!
      rel_path.should == "#{FIXTURE_ROOT}/app/javascripts/file.js"
    end
  end

  describe "#rel" do
    it { abs_path.rel.should == "app/javascripts/file.js" }
    it { rel_path.rel.should == "app/javascripts/file.js" }
  end
  
  describe "#rel!" do
    it do
      abs_path.rel!
      abs_path.should == "app/javascripts/file.js"
    end
    
    it do
      rel_path.rel!
      rel_path.should == "app/javascripts/file.js"
    end
  end
end

# describe JsPath do
#   context "simplified js path" do
#     it_behaves_like 'path', JS_PATH, JS_EXT do
#       let(:path) { JsPath.new('file.js') }
#     end
#   end
#     
#   context "absoluted js path" do
#     it_behaves_like 'path', JS_PATH, JS_EXT do
#       let(:path) { JsPath.new("#{FIXTURE_ROOT}/#{JS_PATH}/file.js") }
#     end
#   end
# end
# 
# describe CssPath do
#   context "simplified js path" do
#     it_behaves_like 'path', CSS_PATH, CSS_EXT do
#       let(:path) { CssPath.new('file.css') }
#     end
#   end
#     
#   context "absoluted js path" do
#     it_behaves_like 'path', CSS_PATH, CSS_EXT do
#       let(:path) { CssPath.new("#{FIXTURE_ROOT}/#{CSS_PATH}/file.css") }
#     end
#   end
# end
