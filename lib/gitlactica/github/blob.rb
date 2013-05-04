module Gitlactica
  module GitHub
    Blob = Struct.new(:sha, :path, :size) do
      def self.from_api(json)
        new(
          json.fetch('sha'),
          json.fetch('path'),
          json.fetch('size')
        )
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
