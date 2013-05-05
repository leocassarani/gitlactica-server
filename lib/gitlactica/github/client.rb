module Gitlactica
  module GitHub
    module Client
      def self.get_json(path, query = {})
        response = api_request.get(path, query, headers)
        Yajl::Parser.parse(response.body)
      end

      def self.post_url(url, query = {})
        response = url_request(url).post do |req|
          req.body = query
          req.headers['Accept'] = 'application/json'
        end
        Yajl::Parser.parse(response.body)
      end

      private

      def self.headers
        headers = { 'User-Agent' => Config::USER_AGENT }

        #if GitHub::Auth.authenticatable?
          #headers['Authorization'] = [GitHub::Auth.username, GitHub::Auth.password]
        #end

        headers
      end

      def self.api_request
        url_request(Config::GITHUB_API_URL)
      end

      def self.url_request(url)
        Faraday.new(url: url)
      end
    end
  end
end
