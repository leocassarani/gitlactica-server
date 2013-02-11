require_relative 'integration_helper'

describe "Gitlactica" do
  include EventMachineHelper
  include GitHubApiHelper
  include JSONHelper

  it "given a list of repos to subscribe to, fetches them from GitHub then sends back all recent unique committers" do
    EM.run {
      Gitlactica::Application.run

      mock_github_api('localhost', 3333)

      websocket = EM::WebSocketClient.connect("ws://localhost:8080")

      websocket.callback do
        websocket.send_msg(
          to_json(
            event: "subscribe",
            data: {
              repos: ["garybernhardt/raptor"]
            }
          )
        )
      end

      websocket.stream do |json|
        EM.stop_event_loop

        from_json(json).should == {
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
        }
      end

      fail_after(0.3, "No message received") do
        websocket.close_connection
      end
    }
  end
end
