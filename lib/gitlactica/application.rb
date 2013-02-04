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
        ws.onopen  { @clients << ws }
        ws.onclose { @clients.delete(ws) }
      end
    end
  end
end
