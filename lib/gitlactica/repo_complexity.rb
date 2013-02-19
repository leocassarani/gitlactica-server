module Gitlactica
  module RepoComplexity
    KNOWN_EXTENSIONS = %w(c cc cpp cxx h hs java js m php pl py rb)

    def self.for_tree(tree)
      blobs = tree.blobs.select { |blob| interesting_blob?(blob) }
      total = blobs.map(&:size).inject(:+)
      count = blobs.count
      (total / count).round
    end

    private

    def self.interesting_blob?(blob)
      KNOWN_EXTENSIONS.include?(blob.extension)
    end
  end
end
