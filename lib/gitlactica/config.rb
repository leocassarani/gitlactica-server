module Gitlactica
  module Config
    CONFIG_DIR     = File.expand_path('../../../config', __FILE__)
    GITHUB_API_URL = ENV.fetch('GITHUB_API_URL') { "https://api.github.com" }
    GITHUB_WEB_URL = ENV.fetch('GITHUB_WEB_URL') { "https://github.com" }
    USER_AGENT     = "Gitlactica/alpha (users/carlmw, users/leocassarani)"

    def self.github_client_id
      ENV.fetch('GITHUB_CLIENT_ID') { oauth['client']['id'] }
    end

    def self.github_client_secret
      ENV.fetch('GITHUB_CLIENT_SECRET') { oauth['client']['secret'] }
    end

    def self.oauth
      path = file_path('oauth.yml')
      YAML.load_file(path)
    end

    def self.languages
      path = file_path('languages.yml')
      YAML.load_file(path)
    end

    private

    def self.file_path(filename)
      File.join(CONFIG_DIR, filename)
    end
  end
end
