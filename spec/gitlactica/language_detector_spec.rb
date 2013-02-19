require './lib/gitlactica/language'
require './lib/gitlactica/language_detector'

module Gitlactica
  describe Gitlactica::LanguageDetector do
    context "when a language exists for the given extension" do
      let(:languages) { {
        'C++' => {
          'type' => 'programming',
          'color' => "#f34b7d",
          'primary_extension' => '.cpp',
          'extensions' => ['.cxx', '.hh']
        }
      } }

      let(:cpp) {
        Language.new(
          name: "C++",
          type: 'programming',
          color: "#f34b7d"
        )
      }

      it "finds a language based on its primary extension" do
        detector = LanguageDetector.new(languages)
        detector.detect('.cpp').should == cpp
      end

      it "finds a language based on one of its secondary extensions" do
        detector = LanguageDetector.new(languages)
        detector.detect('.hh').should == cpp
      end
    end

    context "when the language for the extension isn't known" do
      it "returns a null language object" do
        detector = LanguageDetector.new({})
        detector.detect('.txt').should_not be_programming
      end
    end
  end
end
