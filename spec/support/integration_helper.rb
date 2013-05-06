ENV['RACK_ENV'] = 'test'
ENV['GITHUB_API_URL'] = 'http://localhost:3333'
ENV['GITHUB_WEB_URL'] = 'http://localhost:3333'

require 'gitlactica/api/app'
require 'rack/test'
require 'thin'
require 'yajl'

require './spec/support/authentication_helper'
require './spec/support/json_helper'
require './spec/support/github_api_helper'
require './spec/support/rack_integration_helper'

RSpec.configure do |config|
  config.after(:each) do
    Gitlactica::Database.redis.flushdb
    Gitlactica::Database.clear_connection!
  end
end
