require './lib/gitlactica/language_groups'

module Gitlactica
  class Language; end

  describe Gitlactica::LanguageGroups do
    it "returns an empty hash when given an empty array" do
      LanguageGroups.assign([]).should == {}
    end

    context "when given files associated with known languages" do
      let(:ruby) { mock(:ruby, name: "Ruby") }
      let(:html) { mock(:ruby, name: "HTML") }

      before do
        Language.stub(:for_extension).with('.rb') { ruby }
        Language.stub(:for_extension).with('.html') { html }
      end

      it "returns a hash of inferred language to file paths" do
        LanguageGroups.assign([
          "lib/gitlactica.rb",
          "public/index.html"
        ]).should == {
          'Ruby' => ["lib/gitlactica.rb"],
          'HTML' => ["public/index.html"]
        }
      end

      it "groups multiple files by their language" do
        LanguageGroups.assign([
          "lib/gitlactica.rb",
          "config/boot.rb"
        ]).should == {
          'Ruby' => ["lib/gitlactica.rb", "config/boot.rb"]
        }
      end
    end

    context "when given files with unknown language" do
      let(:unknown) { mock(:unknown, name: "Unknown") }
      before { Language.stub(:for_extension) { unknown } }

      it "groups them together" do
        LanguageGroups.assign([
          "Capfile",
          "textures/ship.png"
        ]).should == {
          'Unknown' => ["Capfile", "textures/ship.png"]
        }
      end
    end
  end
end
