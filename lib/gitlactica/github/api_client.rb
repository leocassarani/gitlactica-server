module Gitlactica
  module GitHub
    module APIClient
      def self.get_json(path, query = {})
        api_request.get(path, query, headers).body
      end

      private

      def self.headers
        { 'User-Agent' => Config::USER_AGENT }
      end

      def self.api_request
        Faraday.new(url: Config::GITHUB_API_URL) do |conn|
          conn.response :json, content_type: /\bjson$/
          conn.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
