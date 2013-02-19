module Gitlactica
  module GitHub
    class Blob
      def self.from_api(json)
        new(
          path: json.fetch('path'),
          sha: json.fetch('sha'),
          size: json.fetch('size')
        )
      end

      attr_reader :sha, :path, :size

      def initialize(attr = {})
        @sha  = attr.fetch(:sha)
        @path = attr.fetch(:path, '')
        @size = attr.fetch(:size, 0)
      end

      def extension
        File.extname(path)
      end

      def ==(obj)
        obj.is_a?(self.class) && obj.sha == sha
      end

      alias :eql? :==

      def hash
        sha.hash
      end
    end
  end
end
