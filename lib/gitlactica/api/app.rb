require 'sinatra'
require 'gitlactica'

require_relative 'base'
require_relative 'auth'
require_relative 'repos'
require_relative 'static'
require_relative 'user'

module Gitlactica
  module Api
    class App
      def initialize
        @app = Rack::Builder.app do
          map('/auth')  { run Auth.new }
          map('/repos') { run Repos.new }
          map('/user')  { run User.new }
          run Static.new unless production?
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
