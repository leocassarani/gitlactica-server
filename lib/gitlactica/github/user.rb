module Gitlactica
  module GitHub
    User = Struct.new(:login) do
      class << self
        def current_user(token)
          json = APIClient.with_token(token) do |api|
            api.get_json("/user")
          end
          from_api(json)
        end

        def from_api(json)
          return if json.nil?
          new(json.fetch('login'))
        end

        alias :from_commit :from_api

        def from_committer(json)
          return if json.nil?
          new(json.fetch('username'))
        end
      end

      def repos
        @repos ||= GitHub::Repo.all_by_user(self)
      end
    end
  end
end
