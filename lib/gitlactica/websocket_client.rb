module Gitlactica
  class WebSocketClient
    class InvalidMessageError < StandardError ; end

    def initialize(socket, subscriptions)
      @socket        = socket
      @subscriptions = subscriptions
    end

    # Processes an incoming message from the WebSocket
    # msg - The Gitlactica::Message to be processed
    def process(msg)
      case msg.type
      when 'login'
        Responders::Login.respond(msg.data, self)
      when 'subscribe'
        Responders::Subscription.respond(msg.data, self, @subscriptions)
      else
        raise InvalidMessageError
      end
    end

    def send_event(event)
      send_msg(:commits, event.to_h)
    end

    def send_msg(event, data)
      msg = make_msg(event, data)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end

    private

    def make_msg(event, data)
      { event: event, data: data }
    end
  end
end
