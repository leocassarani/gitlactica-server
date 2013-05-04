module Gitlactica
  class Language
    class Library
      attr_reader :languages

      def initialize(languages, klass = Language)
        @languages = languages
        @klass     = klass
        @cache     = {}
      end

      def with_name(name)
        cache(name) do
          if languages.has_key?(name)
            hash = languages.fetch(name)
            @klass.from_hash(name, hash)
          else
            unknown_language
          end
        end
      end

      def unknown_language
        @klass.unknown
      end

      private

      def cache(name, &block)
        @cache[name] ||= block.call
      end
    end
  end
end
