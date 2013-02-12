module Gitlactica
  module Config
    GITHUB_API_URL = ENV.fetch('GITHUB_API_URL') { "https://api.github.com" }
  end
end
