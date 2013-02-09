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
          repos = json.map { |hash| from_api(hash) }
          block.call(repos)
        end
      end

      def self.from_api(json)
        new(
          name: json.fetch('name'),
          full_name: json.fetch('full_name'),
          language: json.fetch('language', nil),
          description: json.fetch('description', ''),
        )
      end

      attr_reader :full_name, :name, :language, :description

      def initialize(attr = {})
        @full_name   = attr.fetch(:full_name)
        @name        = attr.fetch(:name, '')
        @language    = attr.fetch(:language, nil)
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
          language: language,
          description: description
        }
      end
    end
  end
end
