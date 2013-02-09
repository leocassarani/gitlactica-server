require_relative 'integration_helper'

describe "Gitlactica" do
  include EventMachineHelper
  include GitHubApiHelper
  include JSONHelper

  it "given a GitHub login over WebSocket, fetches the user's repos and sends them back" do
    EM.run {
      Gitlactica::Application.run

      mock_github_api('localhost', 3333)

      websocket = EM::WebSocketClient.connect("ws://localhost:8080")

      websocket.callback do
        websocket.send_msg(
          to_json(
            event: "login",
            data: {
              login: "defunkt"
            }
          )
        )
      end

      websocket.stream do |json|
        EM.stop_event_loop

        from_json(json).should == {
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
        }
      end

      fail_after(0.3, "No message received") do
        websocket.close_connection
      end
    }
  end
end
