module Gitlactica
  module GitHub
    Repo = Struct.new(:full_name, :language, :description) do
      def self.all_by_user(user)
        json = GitHub::APIClient.get_json("users/#{user.login}/repos")
        json.map { |hash| from_api(hash) }
      end

      def self.from_api(json)
        GitHub::RepoMapper.from_api(json, self)
      end

      def recent_commits
        GitHub::Commit.recent_commits(self)
      end

      def tree
        # TODO: use a repo's default branch, which may not be "master"
        GitHub::Tree.for_repo(self, 'master')
      end

      def to_h
        {
          full_name: full_name,
          language: language.name,
          color: language.color,
          description: description
        }
      end

      def ==(obj)
        obj.is_a?(self.class) && obj.full_name == full_name
      end

      alias :eql? :==

      def hash
        full_name.hash
      end
    end
  end
end
