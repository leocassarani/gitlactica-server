require 'gitlactica/github/repo'

module Gitlactica::GitHub
  describe "equality" do
    let(:ruby) { mock(:ruby) }
    let(:python) { mock(:python) }

    it "is equal to a repository with the same full name" do
      one = Repo.new("lostisland/faraday", ruby)
      two = Repo.new("lostisland/faraday", python)
      one.should == two
    end

    it "is different from repos with a different full name" do
      one = Repo.new("tcrayford/value")
      two = Repo.new("garybernhardt/value")
      one.should_not == two
    end
  end
end
