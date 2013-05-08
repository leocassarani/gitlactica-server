module Gitlactica
  module Api
    class Repos < Base
      get '/' do
        repos = GitHub::Repo.for_current_user(github_token)
        to_json repos.map(&:to_h)
      end
    end
  end
end
