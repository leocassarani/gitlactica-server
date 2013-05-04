module Gitlactica
  module Api
    class AccessToken < Sinatra::Base
      before do
        access_token = token
        halt 403, 'access denied' unless access_token
      end

      private

      def token
        token = params.fetch('access_token', '')
        token unless token.empty?
      end
    end
  end
end
