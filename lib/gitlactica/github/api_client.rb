module Gitlactica
  module GitHub
    class APIClient
      AUTHORIZATION = 'Authorization'.freeze
      USER_AGENT    = 'User-Agent'.freeze

      def self.with_token(token)
        yield new(token)
      end

      attr_reader :token

      def initialize(token)
        @token = token
      end

      def get_json(path, params = {})
        response = api_request.get(path, params, headers)
        response.body
      end

      private

      def api_request
        Faraday.new(url: Config::GITHUB_API_URL) do |faraday|
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  Faraday.default_adapter
        end
      end

      def headers
        head = { USER_AGENT => Config::USER_AGENT }
        head.merge!(AUTHORIZATION => "token #{token}") if token
        head
      end
    end
  end
end
