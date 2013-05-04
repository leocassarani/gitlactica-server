require 'gitlactica/language/library'

module Gitlactica
  describe Gitlactica::Language::Library do
    let(:klass) { mock(:klass) }

    context "when the given language name is known" do
      let(:attr) { {
        'type' => 'programming',
        'color' => "#701516",
        'primary_extension' => '.rb'
      } }

      let(:languages) { { 'Ruby' => attr } }

      let(:ruby) { mock(:ruby) }
      before { klass.stub(:from_hash).with("Ruby", attr) { ruby } }

      it "instantiates a language with the right attributes" do
        library = Language::Library.new(languages, klass)
        library.with_name("Ruby").should == ruby
      end
    end

    context "when the language isn't known" do
      let(:languages) { {} }

      let(:unknown) { mock(:unknown) }
      before { klass.stub(:unknown) { unknown } }

      it "returns the unknown language instance" do
        library = Language::Library.new(languages, klass)
        library.with_name("C++").should == unknown
      end
    end
  end
end
