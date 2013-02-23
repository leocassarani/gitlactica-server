module Gitlactica
  module GitHub
    module CommitMapper
      extend self

      def from_repo(json, klass)
        klass.new(
          sha: json.fetch('sha'),
          committer: GitHub::User.from_commit(committer(json)),
          date: date(json)
        )
      end

      def from_push_event(json, klass)
        klass.new(
          sha: json.fetch('id'),
          committer: GitHub::User.from_committer(committer(json)),
          date: json.fetch('timestamp')
        )
      end

      private

      def date(json)
        commit = json.fetch('commit')
        committer(commit).fetch('date')
      end

      def committer(json)
        json.fetch('committer')
      end
    end
  end
end
