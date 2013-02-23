module Gitlactica
  class SubscriptionRegister
    def initialize
      @repos   = Hash.new { |h, k| h[k] = [] }
      @clients = Hash.new { |h, k| h[k] = [] }
    end

    def clients_for_repo(repo)
      subs = @repos[repo]
      if block_given?
        subs.each { |sub| yield sub.client }
      else
        subs.map(&:client)
      end
    end

    def subscribe(client, repo)
      subscription = Subscription.new(client, repo)

      unless @repos[repo].include?(subscription)
        @repos[repo] << subscription
      end
      unless @clients[client].include?(subscription)
        @clients[client] << subscription
      end

      subscription
    end

    def unsubscribe(client)
      @clients[client].each do |sub|
        repo = sub.repo
        @repos[repo].delete(sub)
      end
      @clients[client] = []
    end
  end
end
