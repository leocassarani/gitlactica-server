require './spec/support/integration_helper'

describe "GET /auth/token" do
  include GitHubApiHelper
  include JSONHelper
  include RackIntegrationHelper

  it "returns an API access token if the user has the right nonce" do
    mock_github_api do
      get '/auth/github/callback', code: "github-oauth-code", state: "somestate"
      follow_redirect!
      get '/auth/token'

      access_token = json_response.fetch(:access_token)
      access_token.should have(40).characters
    end
  end
end
