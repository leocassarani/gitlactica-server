module Gitlactica
  module Database
    extend self

    def clear_connection!
      if @redis
        @redis.client.disconnect
        @redis = nil
      end
    end

    def set_nonce(nonce, github_token, expires_in)
      key = key('nonce', 'github_token', nonce)
      redis.pipelined do
        redis.set(key, github_token)
        redis.expire(key, expires_in)
      end
    end

    def get_nonce(nonce)
      key = key('nonce', 'github_token', nonce)
      redis.get(key)
    end

    def clear_nonce!(nonce)
      key = key('nonce', 'github_token', nonce)
      redis.del(key)
    end

    def set_user_token(user_token, github_token)
      key = key('user_token', 'github_token', user_token)
      redis.set(key, github_token)
    end

    def redis
      @redis ||= Redis.new
    end

    private

    def key(*args)
      args.join(':')
    end
  end
end
