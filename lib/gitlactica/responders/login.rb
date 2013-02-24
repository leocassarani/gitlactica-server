module Gitlactica
  module Responders
    module Login
      extend self

      def respond(msg, client)
        login = msg.fetch(:login)
        user = GitHub::User.new(login)

        user.repos do |repos|
          client.send_msg(:repos, {
            login: login,
            repos: repos.map(&:to_h)
          })
        end
      end
    end
  end
end
