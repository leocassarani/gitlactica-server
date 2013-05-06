module Gitlactica
  module GitHub
    module OAuth
      extend self

      STATE = 'somestate'

      def authorization_url
        [Gitlactica::Config::GITHUB_WEB_URL, 'login', 'oauth', 'authorize'].join('/')
      end

      def authorization_params
        {
          client_id: Gitlactica::Config.github_client_id,
          state: STATE
        }
      end

      def valid_state?(state)
        state == STATE
      end

      def request_access_token(code)
        hash = OAuthClient.post(token_request_path, token_request_params(code))
        hash.fetch('access_token')
      end

      def token_request_path
        ['login', 'oauth', 'access_token'].join('/')
      end

      def token_request_params(code)
        {
          client_id: Gitlactica::Config.github_client_id,
          client_secret: Gitlactica::Config.github_client_secret,
          code: code
        }
      end
    end
  end
end
