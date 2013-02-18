require './lib/gitlactica/repo_complexity'

describe Gitlactica::RepoComplexity do
  let(:tree)  { mock(:tree, blobs: [blob1, blob2]) }
  let(:blob1) { mock(:blob1, size: 40) }
  let(:blob2) { mock(:blob2, size: 20) }

  it "returns the average file size of all blobs" do
    Gitlactica::RepoComplexity.for_tree(tree).should == 30
  end
end
