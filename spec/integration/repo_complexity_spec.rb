require_relative 'integration_helper'

describe "Gitlactica" do
  include GitHubApiHelper
  include WebSocketHelper

  it "given a list of repos to subscribe to, fetches each from GitHub then sends back the numeric complexity of the repo" do
    EM.run {
      mock_github_api('localhost', 3333)

      Gitlactica::Application.run

      mock_websocket('localhost', 8080) do |websocket|
        websocket.should_receive_msg(
          event: "complexity",
          data: {
            repo: "garybernhardt/raptor",
            complexity: 12345
          }
        )

        websocket.send_msg(
          event: "subscribe",
          data: {
            repos: ["garybernhardt/raptor"]
          }
        )

        websocket.timeout_after(0.3)
      end
    }
  end
end
