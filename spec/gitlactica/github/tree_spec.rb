require 'gitlactica/github/blob'
require 'gitlactica/github/tree'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::Tree do
    let(:json) { {
      'sha' => "master",
      'url' => "https://api.github.com/repos/garybernhardt/raptor/git/trees/master",
      'tree' => [
        {
          'mode' => "100644",
          'type' => "blob",
          'sha' => "1878536c4d19fa1f009922ff8f5b423c397775a4",
          'path' => "Gemfile",
          'size' => 67,
          'url' => "https://api.github.com/repos/garybernhardt/raptor/git/blobs/1878536c4d19fa1f009922ff8f5b423c397775a4"
        },
        {
          'mode' => "040000",
          'type' => "tree",
          'sha' => "9282e2bbdda20618e454b4a667f28490712df373",
          'path' => "lib",
          'url' => "https://api.github.com/repos/garybernhardt/raptor/git/trees/9282e2bbdda20618e454b4a667f28490712df373"
        }
      ]
    } }

    it "maps child blobs" do
      blob = Blob.new("1878536c4d19fa1f009922ff8f5b423c397775a4", "Gemfile", 67)
      tree = Tree.from_api(json)
      tree.blobs.should == [blob]
    end
  end
end
