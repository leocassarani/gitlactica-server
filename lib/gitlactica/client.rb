module Gitlactica
  class Client
    class InvalidMessageError < StandardError ; end

    def initialize(socket)
      @socket = socket
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

    private

    def process_login(msg)
      user = GitHub::User.new(msg.fetch(:login))
      user.repos do |repos|
        send_event(:repos, {
          login: user.login,
          repos: repos.map(&:to_hash)
        })
      end
    end

    def process_subscriptions(msg)
      repos = msg.fetch(:repos, [])
      repos.each { |name| process_subscription(name) }
    end

    def process_subscription(repo_name)
      repo = GitHub::Repo.new(full_name: repo_name)
      repo.recent_committers do |committers|
        send_event(:committers, {
          repo: repo.full_name,
          committers: committers.map(&:to_hash)
        })
      end
    end

    def send_event(event, data)
      send_msg(event: event, data: data)
    end

    def send_msg(msg)
      json = Yajl::Encoder.encode(msg)
      @socket.send(json)
    end
  end
end
