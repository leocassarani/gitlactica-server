module Gitlactica
  module GitHub
    class Commit
      def self.recent_commits(repo, &block)
        http = EM::HttpRequest.new('http://localhost:3333').get(path: "repos/#{repo.full_name}/commits")

        http.errback do
          puts "Request failed: #{http.error}"
        end

        http.callback do
          ary = Yajl::Parser.parse(http.response)
          commits = ary.map { |json| from_api(json) }
          block.call(commits)
        end
      end

      def self.from_api(json)
        user = json.fetch('committer')
        committer = GitHub::User.from_api(user)
        new(committer: committer)
      end

      attr_reader :committer

      def initialize(attr = {})
        @committer = attr.fetch(:committer)
      end
    end
  end
end
