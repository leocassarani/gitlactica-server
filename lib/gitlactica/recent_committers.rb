module Gitlactica
  module RecentCommitters
    # The array of commits is assumed to be sorted most-recent first.
    def self.for_commits(commits)
      dates = commits.inject({}) do |memo, commit|
        user = commit.committer
        if user.nil? || memo.has_key?(user)
          memo
        else
          memo.merge(user => commit)
        end
      end
      map_dates(dates)
    end

    private

    def self.map_dates(dates)
      dates.map do |user, commit|
        {
          login: user.login,
          last_commit: commit.date
        }
      end
    end
  end
end
