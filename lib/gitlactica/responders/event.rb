module Gitlactica
  module Responders
    module Event
      extend self

      # This method runs inside an EM.defer block when called by WebHookServer.
      def respond(msg, subscriptions)
        event = GitHub::PushEvent.from_api(msg)
        subscriptions.clients_for_repo(event.repo) do |client|
          EM.next_tick { client.send_msg(:commits, make_msg(event)) }
        end
      end

      private

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
            added: changes.added_count,
            modified: changes.modified_count,
            removed: changes.removed_count
          }
        end
      end
    end
  end
end
