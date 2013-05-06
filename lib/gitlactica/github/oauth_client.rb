module Gitlactica
  module GitHub
    module OAuthClient
      class AcceptJSON < Faraday::Middleware
        def call(env)
          env[:request_headers]['Accept'] = 'application/json'
          @app.call(env)
        end
      end

      Faraday.register_middleware :request,
        accept_json: -> { AcceptJSON }

      def self.post(path, query)
        request.post(path, query).body
      end

      private

      def self.request
        Faraday.new(url: Config::GITHUB_WEB_URL) do |faraday|
          faraday.request  :url_encoded
          faraday.request  :accept_json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end
