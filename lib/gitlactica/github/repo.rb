module Gitlactica
  module GitHub
    class Repo
      def self.all_by_user(user, &block)
        GitHub::Client.get_json("users/#{user.login}/repos") do |json|
          repos = json.map { |hash| from_api(hash) }
          block.call(repos)
        end
      end

      def self.from_api(json)
        GitHub::RepoMapper.from_api(json, self)
      end

      attr_reader :full_name, :name, :language, :description

      def initialize(params)
        @full_name   = params.fetch(:full_name)
        @name        = params.fetch(:name, '')
        @language    = params.fetch(:language, nil)
        @description = params.fetch(:description, '')
      end

      def recent_commits(&block)
        GitHub::Commit.recent_commits(self, &block)
      end

      def tree(&block)
        # TODO: use a repo's default branch, which may not be "master"
        GitHub::Tree.for_repo(self, 'master', &block)
      end

      # Equality

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
