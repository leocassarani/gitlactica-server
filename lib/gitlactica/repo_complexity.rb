module Gitlactica
  module RepoComplexity
    def self.for_tree(tree)
      blobs = tree.blobs
      total = blobs.map(&:size).inject(:+)
      count = blobs.count
      (total / count).round
    end
  end
end
