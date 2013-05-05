module Gitlactica
  module GitHub
    module OAuth
      extend self

      STATE = 'somestate'

      def authorization_url
        [Config::GITHUB_WEB_URL, 'login', 'oauth', 'authorize'].join('/')
      end

      def authorization_params
        {
          client_id: Config.github_client_id,
          state: STATE
        }
      end

      def valid_state?(state)
        state == STATE
      end

      def request_access_token(code)
        hash = GitHub::Client.post_url(token_request_url, token_request_params(code))
        hash.fetch('access_token')
      end

      def token_request_url
        [Config::GITHUB_WEB_URL, 'login', 'oauth', 'access_token'].join('/')
      end

      def token_request_params(code)
        {
          client_id: Config.github_client_id,
          client_secret: Config.github_client_secret,
          code: code
        }
      end
    end
  end
end
