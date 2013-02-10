module Gitlactica
  module GitHub
    module Client
      BASE_URL = 'http://localhost:3333'

      def self.get_json(path, &block)
        http = EM::HttpRequest.new(BASE_URL).get(path: path)
        http.errback { puts "Request failed: #{http.error}" }
        http.callback do
          json = Yajl::Parser.parse(http.response)
          block.call(json)
        end
      end
    end
  end
end
