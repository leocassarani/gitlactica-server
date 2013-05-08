require './spec/support/integration_helper'

describe "GET /user" do
  include JSONHelper
  include GitHubApiHelper
  include RackIntegrationHelper

  before do
    Gitlactica::DB::UserToken.new('celluloid-token', 'github-access-token').save
  end

  context "with a new user" do
    it "returns information about the user and empty subscriptions" do
      mock_github_api do
        get '/user', access_token: 'celluloid-token'
        json_response.should == {
          login: 'celluloid',
          new_user: true,
          subscriptions: []
        }
      end
    end
  end
end
