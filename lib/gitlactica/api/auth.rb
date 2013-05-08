module Gitlactica
  module Api
    class Auth < Base
      get '/login' do
        redirect build_url(GitHub::OAuth.authorization_url, GitHub::OAuth.authorization_params)
      end

      get '/github/callback' do
        code, state = param(:code), param(:state)
        halt 401 unless code && state && GitHub::OAuth.valid_state?(state)

        token = GitHub::OAuth.request_token(code)
        nonce = DB::Nonce.create(token)

        session[:nonce] = nonce.to_s
        redirect '/'
      end

      get '/token' do
        halt 403 unless has_nonce?

        nonce = DB::Nonce.find(session[:nonce]) or halt 403
        user_token = DB::UserToken.create(nonce.token)

        to_json(access_token: user_token.to_s)
      end

      private

      def param(key)
        key = String(key)
        params[key] unless params.fetch(key, '').empty?
      end

      def has_nonce?
        session[:nonce] && !session[:nonce].empty?
      end

      def build_url(base, query)
        [base, Rack::Utils.build_query(query)].join('?')
      end
    end
  end
end
