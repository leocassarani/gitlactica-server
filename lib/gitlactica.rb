require 'eventmachine'
require 'em-http-request'
require 'em-websocket'
require 'thin'
require 'yajl'
require 'yaml'

require_relative 'gitlactica/config'
require_relative 'gitlactica/file_list'
require_relative 'gitlactica/github'
require_relative 'gitlactica/language'
require_relative 'gitlactica/message'
require_relative 'gitlactica/message_router'
require_relative 'gitlactica/subscription_register'
require_relative 'gitlactica/recent_committers'
require_relative 'gitlactica/responders'
require_relative 'gitlactica/repo_complexity'
require_relative 'gitlactica/webhook_server'
require_relative 'gitlactica/websocket_server'
require_relative 'gitlactica/websocket_client'

module Gitlactica
  class Application
    def self.run
      new.run
    end

    def initialize
      @subscriptions = SubscriptionRegister.new
      @router = MessageRouter.new(@subscriptions)
    end

    def run
      WebSocketServer.start(@router, @subscriptions, host: 'localhost', port: 8080)

      webhook = WebHookServer.new(@subscriptions)
      Thin::Logging.silent = true
      Thin::Server.start(webhook, 'localhost', 3000)
    end
  end
end
