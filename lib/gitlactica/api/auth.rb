module Gitlactica
  module Api
    class Auth < Base
      get '/login' do
        redirect build_url(GitHub::OAuth.authorization_url, GitHub::OAuth.authorization_params)
      end

      get '/github/callback' do
        code, state = param(:code), param(:state)
        halt 401 unless code && state && GitHub::OAuth.valid_state?(state)

        github_token = GitHub::OAuth.request_access_token(code)
        session[:nonce] = Gitlactica::AccessToken.make_nonce!(github_token)
        redirect '/'
      end

      get '/token' do
        halt 403 unless nonce

        token = Gitlactica::AccessToken.with_nonce(nonce)
        token.make_user_token!

        session.delete(:nonce)
        to_json(access_token: token.user_token)
      end

      private

      def build_url(base, query)
        [base, Rack::Utils.build_query(query)].join('?')
      end

      def param(key)
        key = String(key)
        params[key] unless params.fetch(key, '').empty?
      end

      def nonce
        session[:nonce] unless !session[:nonce] || session[:nonce].empty?
      end
    end
  end
end
