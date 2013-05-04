require 'sinatra'
require 'gitlactica'

require_relative 'base'
require_relative 'access_token'

module Gitlactica
  module Api
    class App
      def initialize
        @app = Rack::Builder.app do
          use AccessToken
          run Base.new
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
