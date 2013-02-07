module Gitlactica
  module GitHub
    module RepoMapper
      def self.from_api(json, klass)
        klass.new(
          name: json.fetch('name'),
          full_name: json.fetch('full_name'),
          description: json.fetch('description', '')
        )
      end
    end
  end
end
