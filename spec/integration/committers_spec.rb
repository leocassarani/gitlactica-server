require_relative 'integration_helper'

describe "Gitlactica" do
  include GitHubApiHelper
  include WebSocketHelper

  it "given a list of repos to subscribe to, fetches each from GitHub then sends back all recent unique committers" do
    EM.run {
      mock_github_api('localhost', 3333)

      Gitlactica::Application.run

      mock_websocket('localhost', 8080) do |websocket|
        websocket.should_receive_msg(
          event: "committers",
          data: {
            repo: "garybernhardt/raptor",
            committers: [
              { login: "garybernhardt", last_commit: "2012-09-23T17:50:51Z" },
              { login: "tmiller", last_commit: "2012-09-20T04:27:46Z" },
              { login: "tcrayford", last_commit: "2012-06-09T12:57:38Z" },
              { login: "dpick", last_commit: "2012-03-18T22:02:36Z" },
              { login: "andrewhr", last_commit: "2012-03-17T00:47:32Z" }
            ]
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
