module Gitlactica
  module GitHub
    module Client
      def self.get_json(path, query = {}, &block)
        http = api_request.get(path: path, query: query)
        http.errback { puts "Request failed: #{http.error}" }
        http.callback do
          json = Yajl::Parser.parse(http.response)
          block.call(json)
        end
      end

      private

      def self.api_request
        EM::HttpRequest.new(Config::GITHUB_API_URL)
      end
    end
  end
end
