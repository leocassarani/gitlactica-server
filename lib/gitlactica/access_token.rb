module Gitlactica
  class AccessToken
    class << self
      def make_nonce(github_token)
        new_token.tap do |nonce|
          DB::Nonce.new(nonce, github_token).save
        end
      end

      def make_user_token(nonce_str)
        nonce = DB::Nonce.find(nonce_str)
        return unless nonce

        new_token.tap do |user_token|
          DB::UserToken.new(user_token, nonce.token).save
          nonce.destroy!
        end
      end

      private

      def new_token
        SecureRandom.hex(20)
      end
    end
  end
end
