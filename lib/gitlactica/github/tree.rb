module Gitlactica
  module GitHub
    class Tree
      def self.for_repo(repo, branch)
        url = "repos/#{repo.full_name}/git/trees/#{branch}"
        json = GitHub::Client.get_json(url, recursive: 1)
        from_api(json)
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
