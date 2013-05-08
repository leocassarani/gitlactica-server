module Gitlactica
  module Api
    class Repos < Base
      get '/' do
        halt 403 unless authenticated?
        repos = GitHub::Repo.for_current_user(github_token)
        to_json repos.map(&:to_h)
      end
    end
  end
end
