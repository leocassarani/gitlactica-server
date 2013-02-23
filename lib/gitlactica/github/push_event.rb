module Gitlactica
  module GitHub
    class PushEvent
      def self.from_api(json)
        commits = json.fetch('commits')
        new(
          repo: GitHub::Repo.from_api(json.fetch('repository')),
          commits: commits.map { |c| GitHub::Commit.from_push_event(c) }
        )
      end

      attr_reader :repo, :commits

      def initialize(params)
        @repo    = params.fetch(:repo)
        @commits = params.fetch(:commits)
      end

      def to_h
        {
          repo: repo.full_name,
          commits: commits.map { |commit|
            { committer: commit.committer.login }
          }
        }
      end
    end
  end
end