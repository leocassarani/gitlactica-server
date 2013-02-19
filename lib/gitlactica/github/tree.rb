module Gitlactica
  module GitHub
    class Tree
      def self.for_repo(repo, branch, &block)
        url = "repos/#{repo.full_name}/git/trees/#{branch}"

        GitHub::Client.get_json(url, recursive: 1) do |json|
          tree = from_api(json)
          block.call(tree)
        end
      end

      def self.from_api(json)
        tree = json.fetch('tree', [])

        blobs = tree
          .select { |blob| blob.fetch('type') == 'blob' }
          .map    { |blob| GitHub::Blob.from_api(blob) }

        new(blobs)
      end

      attr_reader :blobs

      def initialize(blobs)
        @blobs = blobs
      end
    end
  end
end
