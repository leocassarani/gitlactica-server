require 'eventmachine'
require 'em-http-request'
require 'em-websocket'
require 'yajl'
require 'yaml'

require_relative 'gitlactica/client'
require_relative 'gitlactica/config'
require_relative 'gitlactica/github'
require_relative 'gitlactica/message'
require_relative 'gitlactica/subscription'
require_relative 'gitlactica/recent_committers'
require_relative 'gitlactica/repo_complexity'

module Gitlactica
  class Application
    def self.run
      new.run
    end

    def initialize
      @clients = []
    end

    def run
      EM::WebSocket.start(host: 'localhost', port: 8080) do |ws|
        client = Client.new(ws)
        ws.onopen  { client_add(client) }
        ws.onclose { client_remove(client) }
        ws.onmessage { |msg| client_msg(client, msg) }
      end
    end

    private

    def client_add(client)
      @clients << client
    end

    def client_remove(client)
      @clients.delete(client)
    end

    def client_msg(client, json)
      msg = Message.new(json)
      client.process(msg)
    rescue Message::InvalidJSONError, Client::InvalidMessageError
      puts "Invalid message received: #{json}"
    end
  end
end
