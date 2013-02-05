module Gitlactica
  class Client
    attr_reader :user

    def initialize(socket)
      @socket = socket
    end

    def process(msg)
      process_username(msg)
    end

    private

    def process_username(msg)
      username = msg.fetch(:username)
      @user = GitHub::User.new(username)
      @user.fetch_repos do |response|
        send_msg(response)
      end
    end

    def send_msg(msg)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end
  end
end
