require 'gitlactica/github/commit'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::Commit do
    it "is equal to commits with the same SHA" do
      one = Commit.new(sha: "123", committer: "carlmw")
      two = Commit.new(sha: "123", committer: "leocassarani")
      one.should == two
    end

    it "is different from commits with different SHA" do
      Commit.new(sha: "123").should_not == Commit.new(sha: "456")
    end
  end
end
