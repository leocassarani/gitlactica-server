$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'gitlactica/api/app'

run Gitlactica::Api::App.new
