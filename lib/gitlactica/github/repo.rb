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
        new(
          name: json.fetch('name'),
          full_name: json.fetch('full_name'),
          language: json.fetch('language', nil),
          description: json.fetch('description', ''),
        )
      end

      attr_reader :full_name, :name, :language, :description

      def initialize(attr = {})
        @full_name   = attr.fetch(:full_name)
        @name        = attr.fetch(:name, '')
        @language    = attr.fetch(:language, nil)
        @description = attr.fetch(:description, '')
      end

      def recent_commits(&block)
        GitHub::Commit.recent_commits(self, &block)
      end

      def tree(&block)
        # TODO: use a repo's default branch, which may not be "master"
        GitHub::Tree.for_repo(self, 'master', &block)
      end

      def to_h
        {
          name: name,
          full_name: full_name,
          language: language,
          description: description
        }
      end
    end
  end
end
