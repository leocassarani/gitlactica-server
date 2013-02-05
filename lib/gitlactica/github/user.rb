module Gitlactica
  module GitHub
    class User
      attr_reader :username

      def initialize(username)
        @username = username
      end

      def repos(&block)
        GitHub::Repo.all_by_user(self, &block)
      end
    end
  end
end
