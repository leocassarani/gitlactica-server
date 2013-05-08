require './spec/support/integration_helper'

describe "GET /repos" do
  include JSONHelper
  include GitHubApiHelper
  include RackIntegrationHelper

  before do
    Gitlactica::DB::UserToken.new('celluloid-token', 'github-access-token').save
  end

  it "returns the user's repos" do
    mock_github_api do
      get '/repos', access_token: 'celluloid-token'
      json_response.should == [
        {
          full_name: "celluloid/celluloid",
          language: "Ruby",
          color: "#701516",
          description: "Actor-based concurrent object framework for Ruby"
        },
        {
          full_name: "celluloid/celluloid-dns",
          language: "Ruby",
          color: "#701516",
          description: "Celluloid::IO-powered DNS server"
        },
        {
          full_name: "celluloid/celluloid-io",
          language: "Ruby",
          color: "#701516",
          description: "Evented sockets for Celluloid actors"
        },
        {
          full_name: "celluloid/celluloid-logos",
          language: "Unknown",
          color: nil,
          description: "Celluloid project logos in vector and raster format"
        },
        {
          full_name: "celluloid/celluloid-redis",
          language: "Ruby",
          color: "#701516",
          description: "Celluloid::IO support for the redis-rb gem"
        },
        {
          full_name: "celluloid/celluloid-zmq",
          language: "Ruby",
          color: "#701516",
          description: "Celluloid actors that talk over the 0MQ protocol"
        },
        {
          full_name: "celluloid/celluloid.github.com",
          language: "JavaScript",
          color: "#f15501",
          description: "Celluloid web site"
        },
        {
          full_name: "celluloid/dcell",
          language: "JavaScript",
          color: "#f15501",
          description: "Actor-based distributed objects in Ruby based on Celluloid and 0MQ"
        },
        {
          full_name: "celluloid/lattice",
          language: "Ruby",
          color: "#701516",
          description: "A concurrent realtime web framework for Ruby"
        },
        {
          full_name: "celluloid/reel",
          language: "Ruby",
          color: "#701516",
          description: "Celluloid::IO-powered web server"
        }
      ]
    end
  end
end
