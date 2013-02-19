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
        @details ||= begin
          file_path = Config.file_path('auth.yml')

          if File.exists?(file_path)
            yml = YAML.load_file(file_path)
            yml.fetch('github', {})
          else
            {}
          end
        end
      end
    end
  end
end
