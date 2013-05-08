module Gitlactica
  module DB
    class UserToken
      MAKE_TOKEN = -> { SecureRandom.hex(20) }

      def self.create(github_token)
        new(MAKE_TOKEN.call, github_token).save
      end

      def self.find(user_token)
        github_token = DB.redis.get key(user_token)
        new(user_token, github_token) if github_token
      end

      def self.key(user_token)
        DB.key('user_token', user_token)
      end

      attr_reader :user_token, :github_token

      def initialize(user_token, github_token)
        @user_token   = user_token
        @github_token = github_token
      end

      def to_s
        user_token
      end

      def save
        DB.redis.set(key, github_token)
        self
      end

      private

      def key
        self.class.key(user_token)
      end
    end
  end
end
