module Gitlactica
  class EventDispatcher
    class InvalidMessageError < StandardError; end

    attr_reader :subscriptions

    def initialize(subscriptions)
      @subscriptions = subscriptions
    end

    def dispatch(msg)
      begin
        event = GitHub::PushEvent.from_api(msg)
      rescue KeyError => e
        raise InvalidMessageError.new(e.message)
      end
      subscriptions.clients_for_repo(event.repo) do |client|
        client.send_event(event)
      end
    end
  end
end
