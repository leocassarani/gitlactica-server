module Gitlactica
  module Responders
    class Event
      # This method runs inside an EM.defer block when called by WebHookServer.
      def self.respond(msg, subscriptions)
        new(subscriptions).respond(msg)
      end

      def initialize(subscriptions)
        @subscriptions = subscriptions
      end

      def respond(msg)
        event = GitHub::PushEvent.from_api(msg)
        send_commits(event)
        EM.next_tick { send_complexity(event.repo) }
      end

      private

      def send_commits(event)
        send_to_subscribed_clients(event.repo, :commits, make_msg(event))
      end

      def send_complexity(repo)
        repo.tree do |tree|
          EM.defer do
            complexity = RepoComplexity.for_tree(tree)
            send_to_subscribed_clients(repo, :complexity, {
              repo: repo.full_name,
              complexity: complexity
            })
          end
        end
      end

      def send_to_subscribed_clients(repo, type, msg)
        @subscriptions.clients_for_repo(repo) do |client|
          send_msg(client, type, msg)
        end
      end

      def send_msg(client, type, msg)
        EM.next_tick { client.send_msg(type, msg) }
      end

      def make_msg(event)
        {
          repo: event.repo.full_name,
          commits: map_commits(event.commits)
        }
      end

      def map_commits(commits)
        commits.map do |commit|
          changes = commit.changes
          {
            committer: commit.committer.login,
            added: languages(changes.added),
            modified: languages(changes.modified),
            removed: languages(changes.removed)
          }
        end
      end

      def languages(files)
        files.group_by_language
      end
    end
  end
end
