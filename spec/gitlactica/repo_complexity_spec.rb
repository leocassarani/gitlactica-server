require 'gitlactica/github/blob'
require 'gitlactica/repo_complexity'

module Gitlactica
  class Language; end

  describe Gitlactica::RepoComplexity do
    let(:ruby) { GitHub::Blob.new(sha: '123', path: 'lib/raptor.rb', size: 100) }
    let(:txt)  { GitHub::Blob.new(sha: '789', path: 'NOTES.txt', size: 600) }
    let(:js)   { GitHub::Blob.new(sha: '456', path: 'index.js', size: 200) }

    let(:interesting) { mock(:interesting, programming?: true) }
    let(:uninteresting) { mock(:uninteresting, programming?: false) }

    before do
      Language.stub(:for_extension).with('.rb') { interesting }
      Language.stub(:for_extension).with('.js') { interesting }
      Language.stub(:for_extension).with('.txt') { uninteresting }
    end

    let(:tree) { mock(:tree) }

    it "returns the average file size of all interesting blobs" do
      tree.stub(:blobs) { [ruby, js] }
      Gitlactica::RepoComplexity.for_tree(tree).should == 150
    end

    it "ignores uninteresting blobs" do
      tree.stub(:blobs) { [ruby, txt] }
      Gitlactica::RepoComplexity.for_tree(tree).should == 100
    end

    it "returns 0 when there are no interesting blobs" do
      tree.stub(:blobs) { [txt] }
      Gitlactica::RepoComplexity.for_tree(tree).should == 0
    end
  end
end
