module Gitlactica
  module GitHub
    User = Struct.new(:login) do
      def self.from_api(json)
        login = json.fetch('login')
        new(login)
      end

      def repos(&block)
        GitHub::Repo.all_by_user(self, &block)
      end
    end
  end
end
