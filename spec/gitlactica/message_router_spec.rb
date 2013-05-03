require 'gitlactica/message'
require 'gitlactica/message_router'

describe Gitlactica::MessageRouter do
  let(:subscriptions) { mock(:subscriptions) }
  let(:client) { mock(:client) }
  let(:router) { Gitlactica::MessageRouter.new(subscriptions) }

  it "raises an error when given an invalid event type" do
    expect {
      message = Gitlactica::Message.new('whatever', {})
      router.route(message, client)
    }.to raise_error(Gitlactica::MessageRouter::UnroutableMessageError)
  end
end
