require 'eventmachine'
require 'em-http-request'
require 'em-websocket-client'
require 'sinatra'
require 'thin'
require 'yajl'

require './lib/gitlactica'

require './spec/fixtures/fake_github_api'
require './spec/support/eventmachine_helper'
require './spec/support/github_api_helper'
require './spec/support/json_helper'