module Gitlactica
  module Responders
    module Event
      def self.respond(msg, subscriptions)
        event = GitHub::PushEvent.from_api(msg)
        subscriptions.clients_for_repo(event.repo) do |client|
          EM.next_tick { client.send_msg(:commits, event.to_h) }
        end
      end
    end
  end
end
