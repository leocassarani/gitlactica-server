require './lib/gitlactica/github/commit'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::Commit do
    it "is equal to commits with the same SHA" do
      Commit.new(sha: "123").should == Commit.new(sha: "123")
    end

    it "is different from commits with different SHA" do
      Commit.new(sha: "123").should_not == Commit.new(sha: "456")
    end
  end
end
