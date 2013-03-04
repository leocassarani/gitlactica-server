module Gitlactica
  module GitHub
    class Changes
      def self.from_api(json)
        new(
          added: json.fetch('added'),
          modified: json.fetch('modified'),
          removed: json.fetch('removed')
        )
      end

      attr_reader :added, :modified, :removed

      def initialize(params)
        @added = params.fetch(:added, [])
        @modified = params.fetch(:modified, [])
        @removed = params.fetch(:removed, [])
      end
    end
  end
end
