module Gitlactica
  module DB
    class UserToken
      attr_reader :user_token, :github_token

      def initialize(user_token, github_token)
        @user_token   = user_token
        @github_token = github_token
      end

      def save
        DB.redis.set(key, github_token)
      end

      private

      def key
        DB.key('user_token', user_token)
      end
    end
  end
end
