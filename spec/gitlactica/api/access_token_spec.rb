require 'sinatra'
require 'rack/test'
require 'gitlactica/api/access_token'

describe Gitlactica::Api::AccessToken do
  include Rack::Test::Methods

  def app
    Gitlactica::Api::AccessToken.new
  end

  it "halts the request with no access_token param" do
    get '/'
    last_response.status.should == 403
  end

  it "halts the request with an empty access_token param" do
    get '/', access_token: ''
    last_response.status.should == 403
  end

  it "allows the request when given an access_token" do
    get '/', access_token: 'atoken'
    last_response.status.should_not == 403
  end
end
