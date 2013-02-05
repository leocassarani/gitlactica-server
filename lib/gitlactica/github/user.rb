module Gitlactica
  module GitHub
    class User
      attr_reader :username

      def initialize(username)
        @username = username
      end

      def fetch_repos(&block)
        http = EM::HttpRequest.new('http://localhost:3333').get(path: "users/#{username}/repos")

        http.callback do
          msg = Yajl::Parser.parse(http.response)
          block.call(msg)
        end
      end
    end
  end
end
