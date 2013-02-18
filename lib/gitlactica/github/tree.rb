module Gitlactica
  module GitHub
    class Tree
      def self.for_repo(repo, branch, &block)
        url = "repos/#{repo.full_name}/git/trees/#{branch}?recursive=1"
        GitHub::Client.get_json(url) do |json|
          tree = from_api(json)
          block.call(tree)
        end
      end

      def self.from_api(json)
        new
      end
    end
  end
end
