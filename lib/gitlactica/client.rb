module Gitlactica
  class Client
    class InvalidMessageError < StandardError ; end

    attr_reader :user

    def initialize(socket)
      @socket = socket
    end

    # Processes an incoming message from the WebSocket
    # msg - The Gitlactica::Message to be processed
    def process(msg)
      case msg.type
      when 'username'
        process_username(msg.data)
      else
        raise InvalidMessageError
      end
    end

    private

    def process_username(msg)
      @user = GitHub::User.new(msg.fetch(:username))

      user.repos do |repos|
        send_event(:repos, {
          username: user.username,
          repos: repos.map(&:to_hash)
        })
      end
    end

    def send_event(event, data)
      send_msg(event: event, data: data)
    end

    def send_msg(msg)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end
  end
end
