module Gitlactica
  module Config
    CONFIG_DIR     = File.expand_path('../../../config', __FILE__)

    GITHUB_API_URL = ENV.fetch('GITHUB_API_URL') { "https://api.github.com" }
    USER_AGENT     = "Gitlactica/alpha (user/carlmw, user/leocassarani)"

    def self.file_path(filename)
      File.join(CONFIG_DIR, filename)
    end
  end
end
