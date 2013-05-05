module Gitlactica
  module Database
    extend self

    def set_nonce(nonce, access_token, expires_in)
      key = key('nonce', 'access_token', nonce)
      redis.pipelined do
        redis.set(key, access_token)
        redis.expire(key, expires_in)
      end
    end

    private

    def redis
      @redis ||= Redis.new
    end

    def key(*args)
      args.join(':')
    end
  end
end
