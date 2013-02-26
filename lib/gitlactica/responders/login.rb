module Gitlactica
  module Responders
    module Login
      extend self

      def respond(msg, client)
        login = msg.fetch(:login)
        user = GitHub::User.new(login)

        user.repos do |repos|
          client.send_msg(:repos, make_msg(login, repos))
        end
      end

      private

      def make_msg(login, repos)
        {
          login: login,
          repos: repos.map { |r| map_repo(r) }
        }
      end

      def map_repo(repo)
        {
          name: repo.name,
          full_name: repo.full_name,
          language: repo.language.name,
          color: repo.language.color,
          description: repo.description
        }
      end
    end
  end
end
