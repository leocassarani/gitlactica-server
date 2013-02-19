module Gitlactica
  module RepoComplexity
    KNOWN_EXTENSIONS = %w(c cc cpp cxx h hs java js m php pl py rb)

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
      KNOWN_EXTENSIONS.include?(blob.extension)
    end
  end
end
