module Gitlactica
  module GitHub
    PushEvent = Struct.new(:repo, :commits) do
      def self.from_api(json)
        repository = json.fetch('repository')
        commits = json.fetch('commits')
        new(
          GitHub::Repo.from_api(repository),
          commits.map { |c| GitHub::Commit.from_push_event(c) }
        )
      end
    end
  end
end
