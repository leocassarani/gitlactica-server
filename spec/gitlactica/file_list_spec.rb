require 'gitlactica/file_list'

module Gitlactica
  class Language; end

  describe Gitlactica::FileList do
    describe "equality" do
      it "is equal to another file list containing the same files" do
        FileList.new(["a.rb", "b.js"]).should == FileList.new(["a.rb", "b.js"])
      end

      it "is not equal to a file list containing different files" do
        FileList.new(["a.rb", "b.js"]).should_not == FileList.new(["b.js"])
      end
    end

    describe "group_by_language" do
      it "returns an empty hash when given an empty array" do
        FileList.new([]).group_by_language.should == {}
      end

      context "when given files associated with known languages" do
        let(:ruby) { mock(:ruby, name: "Ruby") }
        let(:html) { mock(:ruby, name: "HTML") }

        before do
          Language.stub(:for_extension).with('.rb') { ruby }
          Language.stub(:for_extension).with('.html') { html }
        end

        it "returns a hash of inferred language to file paths" do
          list = FileList.new(["lib/gitlactica.rb", "public/index.html"])
          list.group_by_language.should ==  {
            'Ruby' => ["lib/gitlactica.rb"],
            'HTML' => ["public/index.html"]
          }
        end

        it "groups multiple files by their language" do
          list = FileList.new(["lib/gitlactica.rb", "config/boot.rb"])
          list.group_by_language.should == {
            'Ruby' => ["lib/gitlactica.rb", "config/boot.rb"]
          }
        end
      end

      context "when given files with unknown language" do
        let(:unknown) { mock(:unknown, name: "Unknown") }
        before { Language.stub(:for_extension) { unknown } }

        it "groups them together" do
          list = FileList.new(["Capfile", "textures/ship.png"])
          list.group_by_language.should == {
            'Unknown' => ["Capfile", "textures/ship.png"]
          }
        end
      end
    end
  end
end
