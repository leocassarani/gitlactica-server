module Gitlactica
  class Subscription
    attr_reader :repo

    def initialize(repo)
      @repo = repo
    end

    def committers(&block)
      repo.recent_commits do |commits|
        EM.defer do
          committers = RecentCommitters.for_commits(commits)
          EM.next_tick { block.call(committers) }
        end
      end
    end

    def complexity(&block)
      repo.tree do |tree|
        EM.defer do
          complexity = RepoComplexity.for_tree(tree)
          EM.next_tick { block.call(complexity) }
        end
      end
    end
  end
end
