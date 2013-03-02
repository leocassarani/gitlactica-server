module Gitlactica
  module GitHub
    User = Struct.new(:login) do
      def self.from_commit(json)
        return if json.nil?
        new(json.fetch('login'))
      end

      def self.from_committer(json)
        return if json.nil?
        new(json.fetch('username'))
      end

      def repos(&block)
        GitHub::Repo.all_by_user(self, &block)
      end
    end
  end
end
