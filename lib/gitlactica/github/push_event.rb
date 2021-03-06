module Gitlactica
  module GitHub
    class PushEvent
      def self.from_api(json)
        repository = json.fetch('repository')
        commits = json.fetch('commits')
        new(
          repo: GitHub::Repo.from_api(repository),
          commits: commits.map { |c| GitHub::Commit.from_push_event(c) }
        )
      end

      attr_reader :repo, :commits

      def initialize(params)
        @repo    = params.fetch(:repo)
        @commits = params.fetch(:commits)
      end
    end
  end
end
