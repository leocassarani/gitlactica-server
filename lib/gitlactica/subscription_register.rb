module Gitlactica
  class SubscriptionRegister
    def initialize
      @subs = Hash.new { |h, k| h[k] = [] }
    end

    def subscribe(client, repo)
      subscription = Subscription.new(client, repo)

      unless @subs[repo].include?(subscription)
        @subs[repo] << subscription
      end

      subscription
    end

    def clients_for_repo(repo)
      subs = @subs[repo]
      if block_given?
        subs.each { |sub| yield sub.client }
      else
        subs.map(&:client)
      end
    end
  end
end
