module GitHubApiHelper
  def mock_github_api(host, port)
    Thin::Logging.silent = true
    Thin::Server.start(FakeGitHubApi, host, port)
  end
end
