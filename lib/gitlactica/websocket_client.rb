module Gitlactica
  class WebSocketClient
    class InvalidMessageError < StandardError ; end

    def initialize(socket, router)
      @socket = socket
      @router = router
      register_message_handler
    end

    def send_msg(event, data)
      msg = make_msg(event, data)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end

    private

    def register_message_handler
      @socket.onmessage(&method(:message_handler))
    end

    def message_handler(json)
      msg = Message.from_json(json)
      @router.route(msg, self)
    rescue Message::InvalidJSONError, MessageRouter::UnroutableMessageError
      puts "Invalid message received: #{json}"
    end

    def make_msg(event, data)
      { event: event, data: data }
    end
  end
end
