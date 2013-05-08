module Gitlactica
  module Api
    class User < Base
      get '/' do
        halt 403 unless authenticated?
        user = GitHub::User.current_user(github_token)
        to_json(
          login: user.login,
          new_user: true,
          subscriptions: []
        )
      end
    end
  end
end
