require 'redis'

RSpec.configure do |config|
  config.after(:each) do
    Gitlactica::DB.redis.flushdb
    Gitlactica::DB.clear_connection!
  end
end
