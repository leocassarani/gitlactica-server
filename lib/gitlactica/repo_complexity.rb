module Gitlactica
  module RepoComplexity
    def self.for_tree(tree)
      blobs = tree.blobs.select { |blob| interesting_blob?(blob) }
      count = blobs.count

      if count > 0
        total = blobs.map(&:size).inject(:+)
        (total / count).round
      else
        0
      end
    end

    private

    def self.interesting_blob?(blob)
      Language.for_extension(blob.extension).programming?
    end
  end
end
