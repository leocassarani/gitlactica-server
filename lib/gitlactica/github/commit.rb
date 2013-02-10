module Gitlactica
  module GitHub
    class Commit
      def self.recent_commits(repo, &block)
        GitHub::Client.get_json("repos/#{repo.full_name}/commits") do |json|
          commits = json.map { |commit| from_api(commit) }
          block.call(commits)
        end
      end

      def self.from_api(json)
        committer = json.fetch('committer')
        commit = json.fetch('commit')
        new(
          committer: GitHub::User.from_api(committer),
          date: commit.fetch('committer', {}).fetch('date')
        )
      end

      attr_reader :committer, :date

      def initialize(attr = {})
        @committer = attr.fetch(:committer)
        @date      = attr.fetch(:date)
      end
    end
  end
end
