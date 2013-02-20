require './lib/gitlactica/language_detector'

module Gitlactica
  describe Gitlactica::LanguageDetector do
    let(:library) { mock(:library) }

    context "when a language exists for the given extension" do
      let(:languages) { {
        'C++' => {
          'primary_extension' => '.cpp',
          'extensions' => ['.cxx', '.hh']
        }
      } }

      let(:cpp) { mock(:cpp) }
      before { library.stub(:with_name).with("C++") { cpp } }

      it "finds a language based on its primary extension" do
        detector = LanguageDetector.new(languages, library)
        detector.detect('.cpp').should == cpp
      end

      it "finds a language based on one of its secondary extensions" do
        detector = LanguageDetector.new(languages, library)
        detector.detect('.hh').should == cpp
      end
    end

    context "when the language for the extension isn't known" do
      let(:unknown) { mock(:unknown) }
      before { library.stub(:unknown_language) { unknown } }

      it "returns a null language object" do
        detector = LanguageDetector.new({}, library)
        detector.detect('.txt').should == unknown
      end
    end
  end
end
