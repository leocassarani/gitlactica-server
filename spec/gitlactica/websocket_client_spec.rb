require './lib/gitlactica/websocket_client'

describe Gitlactica::WebSocketClient do
  let(:socket) { mock(:socket) }
  let(:subscriptions) { mock(:subscriptions) }
  let(:client) { Gitlactica::WebSocketClient.new(socket, subscriptions) }

  it "raises an error when given an invalid event type" do
    expect {
      message = mock(:message, type: "whatever")
      client.process(message)
    }.to raise_error(Gitlactica::WebSocketClient::InvalidMessageError)
  end
end
