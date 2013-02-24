module Gitlactica
  class SubscriptionRegister
    def initialize
      @repos   = Hash.new { |h, k| h[k] = [] }
      @clients = Hash.new { |h, k| h[k] = [] }
    end

    def clients_for_repo(repo)
      clients = @clients[repo]
      if block_given?
        clients.each { |client| yield client }
      else
        clients
      end
    end

    def repos_for_client(client)
      @repos[client]
    end

    def subscribe(client, repo)
      @repos[client] << repo   unless @repos[client].include?(repo)
      @clients[repo] << client unless @clients[repo].include?(client)
    end

    def unsubscribe(client)
      @repos[client].each do |repo|
        @clients[repo].delete(client)
      end
      @repos[client] = []
    end
  end
end
