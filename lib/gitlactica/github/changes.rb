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
        @added    = FileList.new(params.fetch(:added, []))
        @modified = FileList.new(params.fetch(:modified, []))
        @removed  = FileList.new(params.fetch(:removed, []))
      end
    end
  end
end
