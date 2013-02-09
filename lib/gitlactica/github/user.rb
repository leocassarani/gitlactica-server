module Gitlactica
  module GitHub
    class User
      def self.from_api(json)
        login = json.fetch('login')
        new(login)
      end

      attr_reader :login

      def initialize(login)
        @login = login
      end

      def repos(&block)
        GitHub::Repo.all_by_user(self, &block)
      end

      def to_hash
        {
          login: login
        }
      end
    end
  end
end
