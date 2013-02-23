module WebSocketHelper
  def mock_websocket(host, port, &block)
    FakeWebSocket.new("ws://#{host}:#{port}", &block)
  end

  class FakeWebSocket
    include EventMachineHelper
    include JSONHelper

    def initialize(endpoint, &block)
      @expected = []
      @socket = EM::WebSocketClient.connect(endpoint)
      @socket.callback { block.call(self) }
      @socket.stream { |json| handle_msg(json) }
    end

    def should_receive_msg(msg)
      @expected << msg
    end

    def send_msg(msg)
      json = to_json(msg)
      @socket.send_msg(json)
    end

    def timeout_after(timeout)
      fail_after(timeout, "No message received") do
        @socket.close_connection
      end
    end

    private

    def handle_msg(json)
      msg = from_json(json)

      if @expected.include?(msg)
        @expected.delete(msg)
      end

      if @expected.empty?
        EM.stop_event_loop
      end
    end
  end
end
