module Gitlactica
  class MessageRouter
    class UnroutableMessageError < StandardError; end

    def initialize(subscriptions)
      @subscriptions = subscriptions
    end

    def route(msg, client)
      case msg.type
      when 'login'
        Responders::Login.respond(msg.data, client)
      when 'subscribe'
        Responders::Subscription.respond(msg.data, client, @subscriptions)
      else
        raise UnroutableMessageError.new(msg)
      end
    end
  end
end
