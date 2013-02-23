ENV['GITHUB_API_URL'] = 'http://localhost:3333'

require 'eventmachine'
require 'em-websocket-client'
require 'sinatra'
require 'thin'

require './lib/gitlactica'

require './spec/support/eventmachine_helper'
require './spec/support/github_api_helper'
require './spec/support/github_webhook_helper'
require './spec/support/json_helper'
require './spec/support/websocket_helper'
require './spec/fixtures/fake_github_api'
