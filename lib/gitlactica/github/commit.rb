module Gitlactica
  module GitHub
    class Commit
      def self.recent_commits(repo, &block)
        GitHub::Client.get_json("repos/#{repo.full_name}/commits") do |json|
          commits = json.map { |commit| from_repo(commit) }
          block.call(commits)
        end
      end

      def self.from_repo(json)
        GitHub::CommitMapper.from_repo(json, self)
      end

      attr_reader :sha, :committer, :date

      def initialize(params)
        @sha = params.fetch(:sha)
        @committer = params.fetch(:committer, nil)
        @date = params.fetch(:date, nil)
      end

      # Equality

      def ==(obj)
        obj.is_a?(self.class) && obj.sha == sha
      end

      alias :eql? :==

      def hash
        sha.hash
      end
    end
  end
end
