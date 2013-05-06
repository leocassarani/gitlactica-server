module Gitlactica
  module FaradayMiddleware
    class ParseJSON < ::FaradayMiddleware::ResponseMiddleware
      define_parser do |body|
        Yajl::Parser.parse(body) unless body.strip.empty?
      end
    end

    Faraday.register_middleware :response,
      :json => lambda { ParseJSON }
  end
end

