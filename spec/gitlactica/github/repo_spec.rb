require 'gitlactica/github/repo'

module Gitlactica::GitHub
  describe "equality" do
    it "is equal to a repository with the same full name" do
      Repo.new(full_name: "technoweenie/faraday").should == Repo.new(full_name: "technoweenie/faraday")
    end

    it "is different from repos with a different full name" do
      Repo.new(full_name: "tcrayford/value").should_not == Repo.new(full_name: "garybernhardt/value")
    end
  end
end
