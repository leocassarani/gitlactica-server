module Gitlactica
  module GitHub
    module Auth
      extend self

      def authenticatable?
        !(username.empty? && password.empty?)
      end

      def username
        @username ||= details.fetch('username', '')
      end

      def password
        @password ||= details.fetch('password', '')
      end

      private

      def details
        @details ||= Config.auth.fetch('github', {})
      end
    end
  end
end
