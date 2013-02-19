module Gitlactica
  class LanguageDetector
    attr_reader :languages, :extensions

    def initialize(languages)
      @languages  = languages
      @extensions = precompute_extensions
      @cache      = {}
    end

    def detect(extension)
      if known_extension?(extension)
        name = extensions.fetch(extension)
        language_with_name(name)
      else
        Language::UnknownLanguage
      end
    end

    private

    def known_extension?(extension)
      extensions.has_key?(extension)
    end

    def language_with_name(name)
      @cache[name] ||= begin
        hash = languages.fetch(name)
        Language.from_hash(name, hash)
      end
    end

    def precompute_extensions
      languages.inject({}) do |memo, (key, language)|
        memo.merge(extensions_hash(language, key))
      end
    end

    def extensions_hash(language, key)
      extensions = []
      extensions << language.fetch('primary_extension')
      extensions.concat language.fetch('extensions', [])
      extensions.inject({}) { |memo, ext| memo.merge(ext => key) }
    end
  end
end
