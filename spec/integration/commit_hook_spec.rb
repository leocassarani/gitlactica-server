require_relative 'integration_helper'

describe "Gitlactica" do
  include GitHubApiHelper
  include GitHubWebHookHelper
  include WebSocketHelper

  it "receives a commit hook and sends the commit data to the client" do
    EM.run {
      mock_github_api('localhost', 3333)

      Gitlactica::Application.run

      mock_websocket('localhost', 8080) do |websocket|
        websocket.should_receive_msg(
          event: "commits",
          data: {
            repo: "carlmw/gitlactica",
            commits: [
              {
                committer: "carlmw",
                added: {
                  JavaScript: [
                    "lib/sky_box.js",
                    "test/sky_box.js"
                  ],
                },
                modified: {
                  HTML: ["index.html"],
                  JavaScript: ["lib/gitlactica.js"],
                  Unknown: ["textures/stars.jpg"]
                },
                removed: {}
              }
            ]
          }
        )

        websocket.expect('committers', 'complexity') do
          mock_github_webhook('localhost', 3000).trigger('gitlactica.json')
        end

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
