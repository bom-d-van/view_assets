require File.expand_path File.dirname(__FILE__) + '/rspec_helper'

describe Directive do
  let(:js_directive) { Directive.new 'js' }
  let(:css_directive) { Directive.new 'css' }

  describe '.new' do
    it { expect { Directive.new('unknown') }.to raise_error(ConfigurationError) }
  end
  
  describe '#parse' do
    it { expect { js_directive.parse('') }.to raise_error(UnknownDirectiveError) }
  end
    
  # TODO refactor all tests bellow following betterspecs.org
  describe 'double-slash(// xxx) sysntax' do
    context 'in javascript' do
      subject { js_directive }
      its(:vendor_directive) { should =~ '//= require_vendor vendor1, vendor2' }
      its(:lib_directive) { should =~ '//= require_lib lib1, lib2' }
      its(:app_directive) { should =~ '//= require app1, app2' }
    end
    
    context "in stylesheet" do
      subject { css_directive }
      its(:vendor_directive) { should_not =~ '//= require_vendor vendor1, vendor2' }
      its(:lib_directive) { should_not =~ '//= require_lib lib1, lib2' }
      its(:app_directive) { should_not =~ '//= require app1, app2' }
    end
    
    it 'should not has any extra spaces or characters at the begin of lines' do
      js_directive.app_directive.should_not =~ ' //= require app1, app2'
      css_directive.app_directive.should_not =~ ' //= require app1, app2'
      # FIXME find a way to generate a character randomly
      js_directive.app_directive.should_not =~ '///= require app1, app2'
      css_directive.app_directive.should_not =~ '///= require app1, app2'
    end
    
    context 'should has both root path of assets and non-modified path params as its parsed result' do
      it 'require_vendor directive' do
        js_directive.parse('//= require_vendor vendor1, vendor2').should == ['vendor', %w(vendor1 vendor2)]
      end

      it 'require_lib directive' do
        js_directive.parse('//= require_lib vendor1, vendor2').should == ['lib', %w(vendor1 vendor2)]
      end
      
      it 'require directive' do
        js_directive.parse('//= require vendor1, vendor2').should == ['app', %w(vendor1 vendor2)]
      end
    end
  end
  
  context 'space-asterisk( * xxx) syntax' do
    it 'should accept "require_vendor" directives' do
      js_directive.vendor_directive.should =~ ' *= require_vendor vendor1, vendor2'
      css_directive.vendor_directive.should =~ ' *= require_vendor vendor1, vendor2'
    end

    it 'should accept "require_lib" syntax' do
      js_directive.lib_directive.should =~ ' *= require_lib lib1, lib2'
      css_directive.lib_directive.should =~ ' *= require_lib lib1, lib2'
    end

    it 'should accept "require" syntax' do
      js_directive.app_directive.should =~ ' *= require app1, app2'
      css_directive.app_directive.should =~ ' *= require app1, app2'
    end

    it 'should not has any extra spaces or characters at the begin of lines' do
      js_directive.app_directive.should_not =~ '  *= require app1, app2'
      css_directive.app_directive.should_not =~ '  *= require app1, app2'
      js_directive.app_directive.should_not =~ '/ *= require app1, app2'
      css_directive.app_directive.should_not =~ '/ *= require app1, app2'
    end
    
    context 'should has both root path of assets and non-modified path params as its parsed result' do
      it 'require_vendor directive' do
        js_directive.parse(' *= require_vendor vendor1, vendor2').should == ['vendor', %w(vendor1 vendor2)]
      end

      it 'require_lib directive' do
        js_directive.parse(' *= require_lib vendor1, vendor2').should == ['lib', %w(vendor1 vendor2)]
      end
      
      it 'require directive' do
        js_directive.parse(' *= require vendor1, vendor2').should == ['app', %w(vendor1 vendor2)]
      end
    end
  end

  context 'slash-asterisk(/* xxx */) syntax' do
    it 'should accept "require_vendor" directives' do
      js_directive.vendor_directive.should =~ '/*= require_vendor vendor1, vendor2 */'
      css_directive.vendor_directive.should =~ '/*= require_vendor vendor1, vendor2 */'
    end

    it 'should accept "require_lib" syntax' do
      js_directive.lib_directive.should =~ '/*= require_lib lib1, lib2 */'
      css_directive.lib_directive.should =~ '/*= require_lib lib1, lib2 */'
    end

    it 'should accept "require" syntax' do
      js_directive.app_directive.should =~ '/*= require app1, app2 */'
      css_directive.app_directive.should =~ '/*= require app1, app2 */'
    end

    it 'should not has any extra spaces or characters at the begin of lines' do
      js_directive.app_directive.should_not =~ ' */= require app1, app2'
      css_directive.app_directive.should_not =~ ' */= require app1, app2'
      css_directive.app_directive.should_not =~ '/*/= require app1, app2'
    end
    
    context 'should has both root path of assets and non-modified path params as its parsed result' do
      it 'require_vendor directive' do
        js_directive.parse('/*= require_vendor vendor1, vendor2 */').should == ['vendor', %w(vendor1 vendor2)]
      end

      it 'require_lib directive' do
        js_directive.parse('/*= require_lib vendor1, vendor2 */').should == ['lib', %w(vendor1 vendor2)]
      end
      
      it 'require directive' do
        js_directive.parse('/*= require vendor1, vendor2 */').should == ['app', %w(vendor1 vendor2)]
      end
    end
  end
end