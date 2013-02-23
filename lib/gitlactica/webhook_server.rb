module Gitlactica
  class WebHookServer
    def initialize(dispatcher)
      @dispatcher = dispatcher
    end

    def call(env)
      request = Rack::Request.new(env)
      response = Rack::Response.new

      if hook?(request)
        EM.defer { process(request) }
        response.status = 200
      else
        response.status = 404
      end
      response.finish
    end

    private

    def hook?(request)
      request.path =~ /^\/hooks\/?$/
    end

    def process(request)
      # TODO: move this into a middleware
      json = request.body.read
      msg = Yajl::Parser.parse(json)
      begin
        @dispatcher.dispatch(msg)
      rescue EventDispatcher::InvalidMessageError
        puts "Invalid message received: #{json}"
      end
    end
  end
end
