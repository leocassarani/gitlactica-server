require 'eventmachine'
require 'em-http-request'
require 'em-websocket'
require 'thin'
require 'yajl'
require 'yaml'

require_relative 'gitlactica/config'
require_relative 'gitlactica/github'
require_relative 'gitlactica/language'
require_relative 'gitlactica/language_detector'
require_relative 'gitlactica/language_groups'
require_relative 'gitlactica/language_library'
require_relative 'gitlactica/message'
require_relative 'gitlactica/subscription_register'
require_relative 'gitlactica/recent_committers'
require_relative 'gitlactica/responders'
require_relative 'gitlactica/repo_complexity'
require_relative 'gitlactica/webhook_server'
require_relative 'gitlactica/websocket_client'

module Gitlactica
  class Application
    def self.run
      new.run
    end

    def initialize
      @clients = []
      @subscriptions = SubscriptionRegister.new
    end

    def run
      EM::WebSocket.start(host: 'localhost', port: 8080) do |ws|
        client = WebSocketClient.new(ws, @subscriptions)
        ws.onopen  { client_add(client) }
        ws.onclose { client_remove(client) }
        ws.onmessage { |msg| client_msg(client, msg) }
      end

      webhook = WebHookServer.new(@subscriptions)
      Thin::Logging.silent = true
      Thin::Server.start(webhook, 'localhost', 3000)
    end

    private

    def client_add(client)
      @clients << client
    end

    def client_remove(client)
      @clients.delete(client)
      @subscriptions.unsubscribe(client)
    end

    def client_msg(client, json)
      msg = Message.new(json)
      client.process(msg)
    rescue Message::InvalidJSONError, WebSocketClient::InvalidMessageError
      puts "Invalid message received: #{json}"
    end
  end
end
