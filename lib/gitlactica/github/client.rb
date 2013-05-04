module Gitlactica
  module GitHub
    module Client
      def self.get_json(path, query = {})
        response = api_request.get(path, query, headers)
        Yajl::Parser.parse(response.body)
      end

      private

      def self.headers
        headers = { 'User-Agent' => Config::USER_AGENT }

        if GitHub::Auth.authenticatable?
          headers['Authorization'] = [GitHub::Auth.username, GitHub::Auth.password]
        end

        headers
      end

      def self.api_request
        Faraday.new(url: Config::GITHUB_API_URL)
      end
    end
  end
end
