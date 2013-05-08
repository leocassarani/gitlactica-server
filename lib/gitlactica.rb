require 'faraday'
require 'faraday_middleware/response_middleware'
require 'redis'
require 'yaml'
require 'yajl'

require_relative 'gitlactica/config'
require_relative 'gitlactica/db'
require_relative 'gitlactica/faraday_middleware'
require_relative 'gitlactica/language'
require_relative 'gitlactica/github'

module Gitlactica

end
