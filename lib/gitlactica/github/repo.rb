module Gitlactica
  module GitHub
    class Repo
      def self.all_by_user(user, &block)
        http = EM::HttpRequest.new('http://localhost:3333').get(path: "users/#{user.username}/repos")

        http.callback do
          json = Yajl::Parser.parse(http.response)
          repos = json.map { |hash| GitHub::RepoMapper.from_api(hash, self) }
          block.call(repos)
        end
      end

      attr_reader :id, :name, :description

      def initialize(attr = {})
        @id = attr.fetch(:id)
        @name = attr.fetch(:name)
        @description = attr.fetch(:description)
      end

      def to_hash
        {
          id: id,
          name: name,
          description: description
        }
      end
    end
  end
end
