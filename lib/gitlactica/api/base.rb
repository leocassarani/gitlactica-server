module Gitlactica
  module Api
    class Base < Sinatra::Base
      enable :sessions
      enable :raise_errors if test?

      before do
        content_type :json
      end

      private

      def github_token
        user_token = DB::UserToken.find(params[:access_token])
        user_token.github_token
      end

      def to_json(obj)
        Yajl::Encoder.encode(obj)
      end
    end
  end
end
