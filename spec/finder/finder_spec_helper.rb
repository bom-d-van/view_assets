require File.expand_path('../rspec_helper', File.dirname(__FILE__))

require 'view_assets'
require 'view_assets/finder/core'

include ViewAssets
include ViewAssets::Finder

shared_examples "finder" do |dir, ext, tag|
  describe "#retrieve_app_asset" do
    pending
  end

  describe "#retrieve" do
    context "straight-forward requirements" do
      it "using default application.#{ext}" do
        result = finder.retrieve('controller1', 'action1')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          lib/#{dir}/lib2.#{ext}
          app/#{dir}/controller1/action1.#{ext}
        )

        result.should =~ expected
      end

      it "using specific controller.#{ext}" do
        result = finder.retrieve('controller2', 'action1')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          app/#{dir}/controller2/controller2.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/controller2/action1.#{ext}
        )

        result.should =~ expected
      end

      it "automatically requiring files in indexed requirements" do
        result = finder.retrieve('controller1', 'action2')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          app/#{dir}/controller1/action2/others.#{ext}
          app/#{dir}/controller1/action2/others2.#{ext}
        )

        result.should =~ expected
      end

      it "using index as manifest in indexed requirements" do
        result = finder.retrieve('controller1', 'action3')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          vendor/#{dir}/vendor2.#{ext}
          lib/#{dir}/lib2.#{ext}
          app/#{dir}/controller1/action3/index.#{ext}
          app/#{dir}/controller1/action3/others.#{ext}
        )

        result.should =~ expected
      end

      it "automatically requiring deeply-nested files in indexed requirements" do
        result = finder.retrieve('controller1', 'action4')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          vendor/#{dir}/vendor2.#{ext}
          lib/#{dir}/lib2.#{ext}
          app/#{dir}/controller1/action4/asset/asset/file.#{ext}
          app/#{dir}/controller1/action4/asset/file.#{ext}
          app/#{dir}/controller1/action4/index.#{ext}
          app/#{dir}/controller1/action4/others.#{ext}
        )

        result.should =~ expected
      end
    end

    context "when requirements are complicating" do
      it "retrieves nested dependences" do
        result = finder.retrieve('controller1', 'action5')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          vendor/#{dir}/vendor3.#{ext}
          vendor/#{dir}/vendor4.#{ext}
          lib/#{dir}/lib4.#{ext}
          lib/#{dir}/lib3.#{ext}
          app/#{dir}/controller1/action5.#{ext}
        )

        result.should =~ expected
      end

      it "retrieves multiple-files libs and vendors" do
        result = finder.retrieve('controller1', 'action6')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          lib/#{dir}/lib5/file1.#{ext}
          lib/#{dir}/lib5/file2.#{ext}
          vendor/#{dir}/vendor5/file1.#{ext}
          vendor/#{dir}/vendor5/file2.#{ext}
          app/#{dir}/controller1/action6/file1.#{ext}
          app/#{dir}/controller1/action6/file2.#{ext}
          app/#{dir}/controller1/action6/index.#{ext}
        )

        result.should =~ expected
      end

      it "retrieves indexed libs and vendors" do
        result = finder.retrieve('controller1', 'action7')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          vendor/#{dir}/vendor5/file1.#{ext}
          vendor/#{dir}/vendor5/file2.#{ext}
          vendor/#{dir}/vendor6/file1.#{ext}
          vendor/#{dir}/vendor6/file2.#{ext}
          vendor/#{dir}/vendor6/index.#{ext}
          lib/#{dir}/lib5/file1.#{ext}
          lib/#{dir}/lib5/file2.#{ext}
          lib/#{dir}/lib6/file1.#{ext}
          lib/#{dir}/lib6/file2.#{ext}
          lib/#{dir}/lib6/index.#{ext}
          app/#{dir}/controller1/action7.#{ext}
        )

        result.should =~ expected
      end

      it "avoids end-less retrieving for closed-loop requirements" do
        result = finder.retrieve('controller1', 'action8')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          lib/#{dir}/lib8.#{ext}
          lib/#{dir}/lib7.#{ext}
          app/#{dir}/controller1/action8.#{ext}
        )

        result.should =~ expected
      end

      it "supports multiple requiring directives" do
        result = finder.retrieve('controller3', 'action1')
        expected = %W(
          vendor/#{dir}/vendor7.#{ext}
          vendor/#{dir}/vendor8.#{ext}
          lib/#{dir}/lib10.#{ext}
          vendor/#{dir}/vendor10.#{ext}
          app/#{dir}/controller3/controller3.#{ext}
          vendor/#{dir}/vendor9.#{ext}
          lib/#{dir}/lib9.#{ext}
          lib/#{dir}/lib11.#{ext}
          app/#{dir}/controller3/action1.#{ext}
        )

        result.should =~ expected
      end

      it "retrieves assets from another action" do
        result = finder.retrieve('controller1', 'action9')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          app/#{dir}/controller1/action10/file1.#{ext}
          app/#{dir}/controller1/action10/file2.#{ext}
          app/#{dir}/controller1/action9.#{ext}
        )

        result.should =~ expected
      end

      it "retrieves assets from another controller" do
        result = finder.retrieve('controller1', 'action11')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          app/#{dir}/controller2/action2/file1.#{ext}
          app/#{dir}/controller2/action2/file2.#{ext}
          app/#{dir}/controller1/action11/index.#{ext}
        )

        result.should =~ expected
      end
    end

    it "support :full options" do
      result = finder.retrieve('controller1', 'action12', :full => true)
      expected = %W(
        #{File.dirname(__FILE__)}/fixtures/vendor/#{dir}/vendor1.#{ext}
        #{File.dirname(__FILE__)}/fixtures/lib/#{dir}/lib1.#{ext}
        #{File.dirname(__FILE__)}/fixtures/app/#{dir}/application.#{ext}
        #{File.dirname(__FILE__)}/fixtures/vendor/#{dir}/vendor11.#{ext}
        #{File.dirname(__FILE__)}/fixtures/lib/#{dir}/lib12.#{ext}
        #{File.dirname(__FILE__)}/fixtures/app/#{dir}/controller1/action12.#{ext}
      )

      result.should =~ expected
    end

    it "support :tagged options" do
      result = finder.retrieve('controller1', 'action12', :tagged => true)
      expected = %W(
        /vendor/#{dir}/vendor1.#{ext}
        /lib/#{dir}/lib1.#{ext}
        /app/#{dir}/application.#{ext}
        /vendor/#{dir}/vendor11.#{ext}
        /lib/#{dir}/lib12.#{ext}
        /app/#{dir}/controller1/action12.#{ext}
      ).map { |asset| tag.call(ext.to_sym, asset) }

      result.should =~ expected
    end

    it "return tagged assets with rel path even :full options is true" do
      result = finder.retrieve('controller1', 'action12', :tagged => true, :full => true)
      expected = %W(
        /vendor/#{dir}/vendor1.#{ext}
        /lib/#{dir}/lib1.#{ext}
        /app/#{dir}/application.#{ext}
        /vendor/#{dir}/vendor11.#{ext}
        /lib/#{dir}/lib12.#{ext}
        /app/#{dir}/controller1/action12.#{ext}
      ).map { |asset| tag.call(ext.to_sym, asset) }

      result.should =~ expected
    end

    context "controller only retrieval" do
      it "retrieve default application assets" do
        result = finder.retrieve('controller1', '')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
        )

        result.should =~ expected
      end

      it "retrieve custom controller assets" do
        result = finder.retrieve('controller3', '')
        expected = %W(
          vendor/#{dir}/vendor7.#{ext}
          vendor/#{dir}/vendor8.#{ext}
          lib/#{dir}/lib10.#{ext}
          vendor/#{dir}/vendor10.#{ext}
          app/#{dir}/controller3/controller3.#{ext}
        )

        result.should =~ expected
      end
    end

    context "when directive params containing file extension" do
      it "retrieve assets" do
        result = finder.retrieve('controller1', 'action13')
        expected = %W(
          vendor/#{dir}/vendor1.#{ext}
          lib/#{dir}/lib1.#{ext}
          app/#{dir}/application.#{ext}
          vendor/#{dir}/vendor5/file1.#{ext}
          lib/#{dir}/lib5/file1.#{ext}
          lib/#{dir}/lib12.#{ext}
          lib/#{dir}/lib13.#{ext}
          app/#{dir}/controller1/action2/others.#{ext}
          app/#{dir}/controller1/action13.#{ext}
        )

        result.should =~ expected
      end
    end

    context "when shallow option is true" do
      it "retrieve assets" do
        result = finder.retrieve('controller1', 'action13', { :shallow => true })
        expected = %W(
          app/#{dir}/application.#{ext}
          vendor/#{dir}/vendor5/file1.#{ext}
          lib/#{dir}/lib5/file1.#{ext}
          lib/#{dir}/lib13.#{ext}
          app/#{dir}/controller1/action2/others.#{ext}
          app/#{dir}/controller1/action13.#{ext}
        )

        result.should =~ expected
      end
    end
  end

  describe "#retrieve_manifest" do
    it "retrieve assets without requirements" do
      result = finder.retrieve_manifest("vendor/#{dir}/vendor11")
      expected = %W(
        vendor/#{dir}/vendor11.#{ext}
      )

      result.should =~ expected
    end

    context "retrieve assets with requirements" do
      it "retrieve assets without shallow option" do
        result = finder.retrieve_manifest("vendor/#{dir}/vendor12")
        expected = %W(
          vendor/#{dir}/vendor11.#{ext}
          vendor/#{dir}/vendor13.#{ext}
          vendor/#{dir}/vendor12.#{ext}
        )

        result.should =~ expected
      end

      it "retrieve with shallow option" do
        result = finder.retrieve_manifest("vendor/#{dir}/vendor12", { :shallow => true })
        expected = %W(
          vendor/#{dir}/vendor13
          vendor/#{dir}/vendor12.#{ext}
        )

        result.should =~ expected
      end
    end
  end
end