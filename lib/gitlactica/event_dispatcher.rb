module Gitlactica
  class EventDispatcher
    attr_reader :subscriptions

    def initialize(subscriptions)
      @subscriptions = subscriptions
    end

    def dispatch(msg)
      # TODO: error handling
      event = GitHub::PushEvent.from_api(msg)
      subscriptions.clients_for_repo(event.repo) do |client|
        client.send_event(event)
      end
    end
  end
end
