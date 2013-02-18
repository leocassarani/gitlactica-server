module Gitlactica
  module GitHub
    Tree = Struct.new(:blobs) do
      def self.for_repo(repo, branch, &block)
        url = "repos/#{repo.full_name}/git/trees/#{branch}?recursive=1"
        GitHub::Client.get_json(url) do |json|
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
    end
  end
end
