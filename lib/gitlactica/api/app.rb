require 'securerandom'
require 'sinatra'
require 'gitlactica'

require_relative 'base'
require_relative 'access_token'
require_relative 'auth'
require_relative 'repos'
require_relative 'static'

module Gitlactica
  module Api
    class App
      def initialize
        @app = Rack::Builder.app do
          map('/auth')  { run Auth.new }
          map('/repos') { run Repos.new }
          run Static.new unless production?
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
