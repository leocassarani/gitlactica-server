module Gitlactica
  module GitHub
    module RepoMapper
      extend self

      def from_api(json, klass)
        klass.new(
          name: json.fetch('name'),
          description: json.fetch('description'),
          full_name: map_full_name(json),
          language: map_language(json)
        )
      end

      private

      def map_full_name(json)
        if json.has_key?('full_name')
          json.fetch('full_name')
        elsif json.has_key?('owner')
          owner = json.fetch('owner')
          [owner.fetch('name'), json.fetch('name')].join('/')
        else
          raise ArgumentError # TODO better exception
        end
      end

      def map_language(json)
        name = json.fetch('language', nil)
        Gitlactica::Language.with_name(name)
      end
    end
  end
end
