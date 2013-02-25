module WebSocketHelper
  def mock_websocket(host, port, &block)
    FakeWebSocket.new("ws://#{host}:#{port}", &block)
  end

  class FakeWebSocket
    include EventMachineHelper
    include JSONHelper

    def initialize(endpoint, &block)
      @assertions   = []
      @expectations = Expectations.new
      @socket = socket(endpoint, block)
    end

    def expect(*events, &block)
      @expectations.expect(events, block)
    end

    def should_receive_msg(msg)
      @assertions << msg
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

    def socket(endpoint, block)
      socket = EM::WebSocketClient.connect(endpoint)
      socket.callback { block.call(self) }
      socket.stream { |json| process_msg(json) }
      socket
    end

    def process_msg(json)
      msg = from_json(json)
      event = msg.fetch(:event)

      if @expectations.expected?(event)
        @expectations.receive(event)
      elsif @assertions.include?(msg)
        @assertions.delete(msg)
      end

      if @assertions.empty? && @expectations.empty?
        EM.stop_event_loop
      end
    end
  end

  class Expectations
    def initialize
      @expectations = {}
    end

    def expect(events, block)
      @expectations[events] = block
    end

    def expected?(event)
      @expectations.any? { |es, _| es.include?(event) }
    end

    def empty?
      @expectations.empty?
    end

    def receive(event)
      events, block = @expectations.find { |es, _| es.include?(event) }

      @expectations.delete(events)
      remainder = events - [event]

      if remainder.empty?
        block.call
      else
        @expectations[remainder] = block
      end
    end
  end
end
