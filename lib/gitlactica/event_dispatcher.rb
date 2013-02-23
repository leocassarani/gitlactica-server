module Gitlactica
  class EventDispatcher
    attr_reader :subscriptions

    def initialize(subscriptions)
      @subscriptions = subscriptions
    end

    def dispatch(msg)
      # TODO
    end
  end
end
