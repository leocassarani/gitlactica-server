module Gitlactica
  class AccessToken
    NONCE_EXPIRES_IN = 5 * 60

    def self.make_nonce!(github_token)
      nonce = SecureRandom.hex(20)
      Gitlactica::Database.set_nonce(nonce, github_token, NONCE_EXPIRES_IN)
      nonce
    end

    def self.with_nonce(nonce)
      if github_token = Gitlactica::Database.get_nonce(nonce)
        Gitlactica::Database.clear_nonce!(nonce)
        new(nil, github_token)
      end
    end

    attr_reader :user_token, :github_token

    def initialize(user_token, github_token)
      @user_token   = user_token
      @github_token = github_token
    end

    def make_user_token!
      return if user_token
      @user_token = SecureRandom.hex(20)
      Gitlactica::Database.set_user_token(user_token, github_token)
    end
  end
end
