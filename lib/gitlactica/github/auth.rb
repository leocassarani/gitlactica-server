module Gitlactica
  module GitHub
    module Auth
      CONFIG_DIR = File.expand_path('../../../../config', __FILE__)
      AUTH_YML   = File.join(CONFIG_DIR, 'auth.yml')

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
        @details ||= begin
          if File.exists?(AUTH_YML)
            yml = YAML.load_file(AUTH_YML)
            yml.fetch('github', {})
          else
            {}
          end
        end
      end
    end
  end
end
