module Gitlactica
  class LanguageDetector
    attr_reader :extensions, :library

    def initialize(languages, library)
      @extensions = extensions_map(languages)
      @library    = library
    end

    def detect(extension)
      if extensions.has_key?(extension)
        name = extensions.fetch(extension)
        library.with_name(name)
      else
        library.unknown_language
      end
    end

    private

    def extensions_map(languages)
      languages.inject({}) do |memo, (key, language)|
        memo.merge(language_extensions(language, key))
      end
    end

    def language_extensions(language, key)
      extensions = []
      extensions << language.fetch('primary_extension')
      extensions.concat language.fetch('extensions', [])
      extensions.inject({}) { |memo, ext| memo.merge(ext => key) }
    end
  end
end
