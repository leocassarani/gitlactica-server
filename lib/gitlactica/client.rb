module Gitlactica
  class Client
    def initialize(socket)
      @socket = socket
    end

    def process(msg)
      if @username.nil?
        @username = msg.fetch(:username)

        fetch_repos do |response|
          send_msg(response)
        end
      end
    end

    private

    def send_msg(msg)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end

    def fetch_repos(&block)
      http = EM::HttpRequest.new('http://localhost:3333').get(:path => "users/#{@username}/repos")

      http.callback do
        json = http.response
        msg = Yajl::Parser.parse(json)
        block.call(msg)
      end
    end
  end
end
