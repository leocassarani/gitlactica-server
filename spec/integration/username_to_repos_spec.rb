require 'eventmachine'
require 'em-http-request'
require 'em-websocket-client'
require 'sinatra'
require 'thin'
require 'yajl'

require './lib/gitlactica'
require './spec/fixtures/fake_github_api'

describe "Gitlactica" do
  def to_json(hash)
    Yajl::Encoder.encode(hash)
  end

  def from_json(json)
    Yajl::Parser.parse(json, symbolize_keys: true)
  end

  def fail_after(interval, msg)
    EM.add_timer(interval) do
      yield if block_given?
      fail msg
    end
  end

  def mock_github_api(host, port)
    Thin::Logging.silent = true
    Thin::Server.start(FakeGitHubApi, host, port)
  end

  it "given a GitHub username over WebSocket, fetches the user's repos and sends them back" do
    EM.run {
      mock_github_api('localhost', 3333)

      Gitlactica::Application.run

      conn = EM::WebSocketClient.connect("ws://localhost:8080")

      conn.callback do
        conn.send_msg(to_json(username: "defunkt"))
      end

      conn.stream do |json|
        EM.stop_event_loop

        from_json(json).should == {
          username: "defunkt",
          repos: [
            {
              id: 1861402,
              name: "ace"
            },
            {
              id: 36,
              name: "ambition"
            }
          ]
        }
      end

      fail_after(0.1, "No message received") do
        conn.close_connection
      end
    }
  end
end
