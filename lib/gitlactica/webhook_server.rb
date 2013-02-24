module Gitlactica
  class WebHookServer
    def initialize(subscriptions)
      @subscriptions = subscriptions
    end

    def call(env)
      request = Rack::Request.new(env)
      response = Rack::Response.new
      if hook?(request)
        EM.defer { process(request) }
        respond_with(response, 200)
      else
        respond_with(response, 404)
      end
    end

    private

    def hook?(request)
      request.path =~ /^\/hooks\/?$/
    end

    def respond_with(response, status)
      response.status = status
      response.finish
    end

    def process(request)
      # TODO: move this into a middleware
      json = request.body.read
      msg = Yajl::Parser.parse(json)
      Responders::Event.respond(msg, @subscriptions)
    end
  end
end
