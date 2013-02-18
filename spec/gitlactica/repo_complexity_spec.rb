require './lib/gitlactica/github/blob'
require './lib/gitlactica/repo_complexity'

module Gitlactica
  describe Gitlactica::RepoComplexity do
    let(:ruby) { GitHub::Blob.new(sha: '123', path: 'lib/raptor.rb', size: 100) }
    let(:txt)  { GitHub::Blob.new(sha: '789', path: 'NOTES.txt', size: 600) }
    let(:js)   { GitHub::Blob.new(sha: '456', path: 'index.js', size: 200) }
    let(:tree) { mock(:tree, blobs: [ruby, txt, js]) }

    it "returns the average file size of all interesting blobs" do
      Gitlactica::RepoComplexity.for_tree(tree).should == 150
    end
  end
end
