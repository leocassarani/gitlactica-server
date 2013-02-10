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
        user = json.fetch('committer')
        committer = GitHub::User.from_api(user)
        new(committer: committer)
      end

      attr_reader :committer

      def initialize(attr = {})
        @committer = attr.fetch(:committer)
      end
    end
  end
end
