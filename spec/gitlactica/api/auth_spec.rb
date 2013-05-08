require 'sinatra'
require 'gitlactica/api/base'
require 'gitlactica/api/auth'
require 'rack/test'

module Gitlactica
  module DB
    class Nonce; end
  end

  module GitHub
    module OAuth; end
  end

  describe Gitlactica::Api::Auth do
    include Rack::Test::Methods

    def app
      Rack::Builder.app do
        map('/auth') { run Gitlactica::Api::Auth.new }
      end
    end

    describe "GET /auth/login" do
      it "redirects to the GitHub OAuth authorization URL" do
        GitHub::OAuth.stub(:authorization_url) { "https://github.com/login/oauth/authorize" }
        GitHub::OAuth.stub(:authorization_params) { {
          client_id: 'clientid',
          state: 'randomstring'
        } }

        get '/auth/login'
        last_response.location.should ==
          "https://github.com/login/oauth/authorize?client_id=clientid&state=randomstring"
      end
    end

    describe "GET /auth/github/callback" do
      let(:token) { 'token' }
      let(:nonce) { mock(:nonce, to_s: 'nonce') }

      before do
        GitHub::OAuth.stub(:request_token) { token }
        DB::Nonce.stub(:create).with(token) { nonce }
      end

      it "returns a 401 with no code" do
        GitHub::OAuth.stub(:valid_state?).with('state') { true }
        get '/auth/github/callback', code: '', state: 'state'
        last_response.status.should eq 401
      end

      it "returns a 401 with no state" do
        get '/auth/github/callback', code: '123abc', state: ''
        last_response.status.should eq 401
      end

      it "returns a 401 with invalid state" do
        GitHub::OAuth.stub(:valid_state?).with('state') { false }
        get '/auth/github/callback', code: '123abc', state: 'state'
        last_response.status.should eq 401
      end

      it "redirects to the index with valid code and state" do
        GitHub::OAuth.stub(:valid_state?).with('state') { true }
        get '/auth/github/callback', code: '123abc', state: 'state'
        last_response.should be_redirect
      end
    end
  end
end
