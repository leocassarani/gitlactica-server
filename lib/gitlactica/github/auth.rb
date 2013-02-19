module Gitlactica
  module GitHub
    module Auth
      CONFIG_DIR = File.expand_path('../../../../config', __FILE__)

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
          yml = YAML.load_file(File.join(CONFIG_DIR, 'auth.yml'))
          yml.fetch('github', {})
        end
      end
    end
  end
end
