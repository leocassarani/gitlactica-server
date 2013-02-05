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

        ws.onopen  { @clients << client }

        ws.onmessage do |json|
          msg = Yajl::Parser.parse(json, symbolize_keys: true)
          client.process(msg)
        end

        ws.onclose do
          @clients.delete(client)
          client = nil
        end
      end
    end
  end
end
