require 'securerandom'
require 'sinatra'
require 'gitlactica'

require_relative 'base'
require_relative 'access_token'
require_relative 'auth'
require_relative 'repos'

module Gitlactica
  module Api
    class App
      def initialize
        @app = Rack::Builder.app do
          map('/auth')  { run Auth.new }
          map('/repos') { run Repos.new }
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
