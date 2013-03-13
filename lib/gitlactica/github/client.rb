module Gitlactica
  module GitHub
    module Client
      def self.get_json(path, query = {}, &block)
        http = api_request.get(head: head, path: path, query: query)
        http.errback { puts "Request failed: #{http.req.uri}" }
        http.callback do
          json = Yajl::Parser.parse(http.response)
          block.call(json)
        end
      end

      private

      def self.head
        head = { 'User-Agent' => Config::USER_AGENT }

        if GitHub::Auth.authenticatable?
          head['Authorization'] = [GitHub::Auth.username, GitHub::Auth.password]
        end

        head
      end

      def self.api_request
        EM::HttpRequest.new(Config::GITHUB_API_URL)
      end
    end
  end
end
