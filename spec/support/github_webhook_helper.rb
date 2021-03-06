module GitHubWebHookHelper
  def mock_github_webhook(host, port)
    FakeGitHubWebHook.new("http://#{host}:#{port}")
  end

  class FakeGitHubWebHook
    GITHUB_HOOKS_DIR = File.expand_path('../../fixtures/github_hooks', __FILE__)

    def initialize(endpoint)
      @endpoint = EM::HttpRequest.new(endpoint)
    end

    def trigger(filename)
      payload = fixture(filename)
      http = @endpoint.post(path: 'hooks', body: payload)
      http.errback { fail(http.error) }
    end

    private

    def fixture(filename)
      path = File.join(GITHUB_HOOKS_DIR, filename)
      File.read(path)
    end
  end
end
