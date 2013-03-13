require 'gitlactica/github/user'
require 'gitlactica/recent_committers'

module Gitlactica
  describe Gitlactica::RecentCommitters do
    def commit(user, date)
      mock(committer: user, date: date)
    end

    let(:tom)  { GitHub::User.new("tcrayford") }
    let(:gary) { GitHub::User.new("garybernhardt") }

    it "returns all recent committers" do
      one = commit(tom, "2013-02-03T15:46:17Z")
      two = commit(gary, "2011-03-19T20:01:39Z")

      RecentCommitters.for_commits([one, two]).should == [
        { login: "tcrayford", last_commit: "2013-02-03T15:46:17Z" },
        { login: "garybernhardt", last_commit: "2011-03-19T20:01:39Z" }
      ]
    end

    it "returns the date of the most recent commit" do
      newer = commit(tom, "2013-02-03T15:46:17Z")
      older = commit(tom, "2013-01-17T14:41:28Z")

      RecentCommitters.for_commits([newer, older]).should == [
        { login: "tcrayford", last_commit: "2013-02-03T15:46:17Z" },
      ]
    end

    it "ignores commits without a committer" do
      has_committer = commit(tom, "2013-02-03T15:46:17Z")
      no_committer  = commit(nil, "2013-01-17T14:41:28Z")

      RecentCommitters.for_commits([has_committer, no_committer]).should == [
        { login: "tcrayford", last_commit: "2013-02-03T15:46:17Z" }
      ]
    end
  end
end
