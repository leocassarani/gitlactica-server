module Gitlactica
  module GitHub
    class Repo
      def self.all_by_user(user, &block)
        http = EM::HttpRequest.new('http://localhost:3333').get(path: "users/#{user.login}/repos")

        http.errback do
          puts "Request failed: #{http.error}"
        end

        http.callback do
          json = Yajl::Parser.parse(http.response)
          repos = json.map { |hash| GitHub::RepoMapper.from_api(hash, self) }
          block.call(repos)
        end
      end

      attr_reader :full_name, :name, :description

      def initialize(attr = {})
        @full_name   = attr.fetch(:full_name)
        @name        = attr.fetch(:name, '')
        @description = attr.fetch(:description, '')
      end

      def recent_committers(&block)
        GitHub::Commit.recent_commits(self) do |commits|
          users = commits.map(&:committer)
          users.uniq! { |user| user.login }
          block.call(users)
        end
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
