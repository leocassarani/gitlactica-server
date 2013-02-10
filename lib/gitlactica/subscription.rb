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
  end
end
