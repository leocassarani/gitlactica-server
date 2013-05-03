module Gitlactica
  class WebSocketServer
    def self.start(*args)
      new(*args).start
    end

    attr_reader :host, :port

    def initialize(router, subscriptions, opts)
      @router = router
      @subscriptions = subscriptions
      @host = opts.fetch(:host)
      @port = opts.fetch(:port)
      @clients = []
    end

    def start
      EM::WebSocket.start(host: host, port: port) do |ws|
        client = WebSocketClient.new(ws, @router)
        ws.onopen  { client_register(client) }
        ws.onclose { client_unregister(client) }
      end
    end

    private

    def client_register(client)
      @clients << client
    end

    def client_unregister(client)
      @clients.delete(client)
      @subscriptions.unsubscribe(client)
    end
  end
end
