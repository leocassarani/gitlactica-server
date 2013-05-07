require_relative 'db/nonce'
require_relative 'db/user_token'

module Gitlactica
  module DB
    def redis
      @redis ||= Redis.new
    end

    module_function :redis

    def key(*args)
      args.join(':')
    end

    module_function :key

    def clear_connection!
      if @redis
        @redis.client.disconnect
        @redis = nil
      end
    end

    module_function :clear_connection!
  end
end
