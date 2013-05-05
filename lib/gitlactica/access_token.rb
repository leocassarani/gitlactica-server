module Gitlactica
  class AccessToken
    NONCE_EXPIRES_IN = 5 * 60

    def self.make_nonce!(token)
      nonce = SecureRandom.hex(20)
      Gitlactica::Database.set_nonce(nonce, token, NONCE_EXPIRES_IN)
      nonce
    end
  end
end
