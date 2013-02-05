require './lib/gitlactica/client'

describe Gitlactica::Client do
  let(:socket) { mock(:socket) }
  let(:client) { Gitlactica::Client.new(socket) }

  it "raises an error when given an invalid event type" do
    expect {
      message = mock(:message, type: "whatever")
      client.process(message)
    }.to raise_error(Gitlactica::Client::InvalidMessageError)
  end
end
