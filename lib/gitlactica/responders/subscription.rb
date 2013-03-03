module Gitlactica
  module Responders
    class Subscription
      def self.respond(msg, client, subscriptions)
        new(client, subscriptions).respond(msg)
      end

      def initialize(client, subscriptions)
        @client = client
        @subscriptions = subscriptions
      end

      def respond(msg)
        repos = msg.fetch(:repos)
        repos.each do |name|
          repo = GitHub::Repo.new(full_name: name)
          subscribe_to(repo)
          send_committers(repo)
          send_complexity(repo)
        end
      end

      private

      def subscribe_to(repo)
        @subscriptions.subscribe(@client, repo)
      end

      def send_committers(repo)
        repo.recent_commits do |commits|
          EM.defer do
            committers = RecentCommitters.for_commits(commits)
            send_msg(:committers, {
              repo: repo.full_name,
              committers: committers
            })
          end
        end
      end

      def send_complexity(repo)
        repo.tree do |tree|
          EM.defer do
            complexity = RepoComplexity.for_tree(tree)
            send_msg(:complexity, {
              repo: repo.full_name,
              complexity: complexity
            })
          end
        end
      end

      def send_msg(type, msg)
        EM.next_tick { @client.send_msg(type, msg) }
      end
    end
  end
end
