module Gitlactica
  class Client
    def initialize(socket)
      @socket = socket
    end

    def process(msg)
      if @username.nil?
        @username = msg.fetch(:username)
        send_msg(
          username: "defunkt",
          repos: [
            {
              id: 1861402,
              name: "ace"
            },
            {
              id: 36,
              name: "ambition"
            }
          ]
        )
      end
    end

    private

    def send_msg(msg)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end
  end
end
