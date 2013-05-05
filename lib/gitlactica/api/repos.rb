module Gitlactica
  module Api
    class Repos < Base
      get '/' do
        repos = GitHub::Repo.all_by_user(current_user)
        to_json(repos.map(&:to_h))
      end
    end
  end
end
