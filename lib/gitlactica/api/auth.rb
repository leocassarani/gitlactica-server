module Gitlactica
  module Api
    class Auth < Base
      get '/login' do
        redirect build_url(GitHub::OAuth.authorization_url, GitHub::OAuth.authorization_params)
      end

      get '/github/callback' do
        halt 401 unless code && state && GitHub::OAuth.valid_state?(state)

        token = GitHub::OAuth.request_access_token(code)
        session[:nonce] = Gitlactica::AccessToken.make_nonce!(token)
        redirect '/'
      end

      get '/token' do
        halt 403, 'invalid nonce' unless nonce
        to_json(access_token: "access-token")
      end

      private

      def build_url(base, query)
        [base, Rack::Utils.build_query(query)].join('?')
      end

      def code
        params['code'] unless params.fetch('code', '').empty?
      end

      def state
        params['state'] unless params.fetch('state', '').empty?
      end

      def nonce
        session['nonce'] unless !session['nonce'] || session['nonce'].empty?
      end
    end
  end
end
