module Gitlactica
  module DB
    class Nonce
      TIME_TO_LIVE = 5 * 60

      def self.find(nonce)
        token = DB.redis.get(key(nonce))
        new(nonce, token) if token
      end

      def self.key(nonce)
        DB.key('nonce', nonce)
      end

      attr_reader :nonce, :token

      def initialize(nonce, token)
        @nonce = nonce
        @token = token
      end

      def save
        redis = DB.redis
        redis.pipelined do
          redis.set(key, token)
          redis.expire(key, TIME_TO_LIVE)
        end
      end

      def destroy!
        DB.redis.del(key)
      end

      private

      def key
        self.class.key(nonce)
      end
    end
  end
end
