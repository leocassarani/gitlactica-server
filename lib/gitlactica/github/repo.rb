module Gitlactica
  module GitHub
    class Repo
      def self.all_by_user(user, &block)
        http = EM::HttpRequest.new('http://localhost:3333').get(path: "users/#{user.username}/repos")

        http.errback do
          puts "Request failed: #{http.error}"
        end

        http.callback do
          json = Yajl::Parser.parse(http.response)
          repos = json.map { |hash| GitHub::RepoMapper.from_api(hash, self) }
          block.call(repos)
        end
      end

      attr_reader :name, :full_name, :description

      def initialize(attr = {})
        @name        = attr.fetch(:name)
        @full_name   = attr.fetch(:full_name)
        @description = attr.fetch(:description)
      end

      def to_hash
        {
          name: name,
          full_name: full_name,
          description: description
        }
      end
    end
  end
end
