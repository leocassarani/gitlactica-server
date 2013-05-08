module Gitlactica
  module DB
    class Nonce
      MAKE_NONCE = -> { SecureRandom.hex(20) }
      TIME_TO_LIVE = 5 * 60

      def self.create(token)
        new(MAKE_NONCE.call, token).save
      end

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

      def to_s
        nonce
      end

      def save
        redis = DB.redis
        redis.pipelined do
          redis.set(key, token)
          redis.expire(key, TIME_TO_LIVE)
        end
        self
      end

      def destroy!
        DB.redis.del(key)
        self
      end

      private

      def key
        self.class.key(nonce)
      end
    end
  end
end
