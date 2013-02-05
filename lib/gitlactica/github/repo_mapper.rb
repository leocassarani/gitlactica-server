module Gitlactica
  module GitHub
    module RepoMapper
      def self.from_api(json, klass)
        klass.new(
          id: json.fetch('id'),
          name: json.fetch('name', ''),
          description: json.fetch('description', '')
        )
      end
    end
  end
end
