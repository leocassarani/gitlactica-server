module Gitlactica
  class Subscription
    attr_reader :repo

    def initialize(repo)
      @repo = repo
    end

    def committers(&block)
      repo.recent_commits do |commits|
        committers = RecentCommitters.for_commits(commits)
        block.call(committers)
      end
    end

    def complexity(&block)
      repo.tree do |tree|
        EM.defer do
          complexity = RepoComplexity.for_tree(tree)
          block.call(complexity)
        end
      end
    end
  end
end
