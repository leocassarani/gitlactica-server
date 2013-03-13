require_relative 'integration_helper'

describe "Gitlactica" do
  include GitHubApiHelper
  include GitHubWebHookHelper
  include WebSocketHelper

  it "receives a commit hook, calculates the new complexity and sends it to the client" do
    EM.run {
      mock_github_api('localhost', 3333)

      Gitlactica::Application.run

      mock_websocket('localhost', 8080) do |websocket|
        websocket.expect('committers', 'complexity') do
          mock_github_webhook('localhost', 3000).trigger('gitlactica.json')
        end

        # Technically cheating as the complexity is the same as before.
        # But because we're not triggering the webhook until we've received
        # the initial complexity event, this is still a valid test.
        websocket.should_receive_msg(
          event: "complexity",
          data: {
            repo: "carlmw/gitlactica",
            complexity: 1531
          }
        )

        websocket.send_msg(
          event: "subscribe",
          data: {
            repos: ["carlmw/gitlactica"]
          }
        )

        websocket.timeout_after(0.3)
      end
    }
  end
end
