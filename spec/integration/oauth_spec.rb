ENV['GITHUB_CLIENT_ID']     = "410f3690eb6a41549c4a"
ENV['GITHUB_CLIENT_SECRET'] = "85070333ddb1083f59de1749392cca1cb068e851"

require './spec/support/integration_helper'

describe "GET /auth/token" do
  include GitHubApiHelper
  include JSONHelper
  include RackIntegrationHelper

  it "returns an API access token if the user has the right nonce" do
    mock_github_api do
      get '/auth/github/callback', code: "github-oauth-code", state: 'somestate'
      follow_redirect!
      get '/auth/token'
      json_response.should == { access_token: "access-token" }
    end
  end
end
