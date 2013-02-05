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
      user.repos do |repos|
        send_msg(
          username: user.username,
          repos: repos.map(&:to_hash)
        )
      end
    end

    def send_msg(msg)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end
  end
end
