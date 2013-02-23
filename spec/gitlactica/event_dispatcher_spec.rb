require './lib/gitlactica/github/push_event'
require './lib/gitlactica/event_dispatcher'

module Gitlactica
  describe Gitlactica::EventDispatcher do
    let(:subscriptions) { mock(:subscriptions) }
    let(:dispatcher) { EventDispatcher.new(subscriptions) }

    it "raises an error when given bad input" do
      expect {
        dispatcher.dispatch({bad: 'input'})
      }.to raise_error(EventDispatcher::InvalidMessageError)
    end
  end
end
