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

      def ==(obj)
        obj.is_a?(self.class) && obj.login == login
      end

      alias :eql? :==

      def hash
        login.hash
      end
    end
  end
end
