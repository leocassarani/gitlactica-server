module Gitlactica
  class WebSocketClient
    class InvalidMessageError < StandardError ; end

    attr_reader :subscriptions

    def initialize(socket, subscriptions)
      @socket        = socket
      @subscriptions = subscriptions
    end

    # Processes an incoming message from the WebSocket
    # msg - The Gitlactica::Message to be processed
    def process(msg)
      case msg.type
      when 'login'
        process_login(msg.data)
      when 'subscribe'
        process_subscriptions(msg.data)
      else
        raise InvalidMessageError
      end
    end

    def send_event(event)
      send_msg(:commits, event.to_h)
    end

    private

    def process_login(msg)
      user = GitHub::User.new(msg.fetch(:login))
      user.repos do |repos|
        send_msg(:repos, {
          login: user.login,
          repos: repos.map(&:to_h)
        })
      end
    end

    def process_subscriptions(msg)
      repos = msg.fetch(:repos, [])
      repos.each do |name|
        repo = GitHub::Repo.new(full_name: name)
        subscription = subscriptions.subscribe(self, repo)
        process_subscription(subscription)
      end
    end

    def process_subscription(subscription)
      subscription.committers do |committers|
        send_msg(:committers, {
          repo: subscription.repo.full_name,
          committers: committers
        })
      end

      subscription.complexity do |complexity|
        send_msg(:complexity, {
          repo: subscription.repo.full_name,
          complexity: complexity
        })
      end
    end

    def send_msg(event, data)
      msg = make_msg(event, data)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end

    def make_msg(event, data)
      { event: event, data: data }
    end
  end
end
