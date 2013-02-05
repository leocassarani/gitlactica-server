require_relative 'integration_helper'

describe "Gitlactica" do
  include EventMachineHelper
  include GitHubApiHelper
  include JSONHelper

  it "given a list of repos to subscribe to, fetches them from GitHub then sends back all recent unique committers" do
    EM.run {
      pending

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
            committers: [
              { login: "garybernhardt" },
              { login: "tmiller" },
              { login: "tcrayford" },
              { login: "dpick" },
              { login: "andrewhr" }
            ]
          }
        }
      end

      fail_after(0.1, "No message received")
    }
  end
end
