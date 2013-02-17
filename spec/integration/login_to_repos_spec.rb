require_relative 'integration_helper'

describe "Gitlactica" do
  include GitHubApiHelper
  include WebSocketHelper

  it "given a GitHub login over WebSocket, fetches the user's repos and sends them back" do
    EM.run {
      mock_github_api('localhost', 3333)

      Gitlactica::Application.run

      mock_websocket('localhost', 8080) do |websocket|
        websocket.should_receive_msg(
          event: "repos",
          data: {
            login: "defunkt",
            repos: [
              {
                name: "ace", full_name: "defunkt/ace",
                language: "JavaScript",
                description: "Ajax.org Cloud9 Editor"
              },
              {
                name: "defunkt.github.com", full_name: "defunkt/defunkt.github.com",
                language: nil,
                description: "My GitHub Page"
              },
              {
                name: "evilbot", full_name: "defunkt/evilbot",
                language: "CoffeeScript",
                description: "an evil bot that's definitely not for convore"
              }
            ]
          }
        )

        websocket.send_msg(
          event: "login",
          data: {
            login: "defunkt"
          }
        )

        websocket.timeout_after(0.3)
      end
    }
  end
end
