module GitHubApiHelper
  HOST = 'localhost'
  PORT = 3333

  def mock_github_api(&block)
    mutex = Mutex.new
    ready = ConditionVariable.new

    Thread.new {
      # Run Thin inside an EventMachine loop so calling .start
      # is non-blocking
      EM.run {
        mutex.synchronize {
          Thin::Logging.silent = true
          Thin::Server.start(FakeGitHubApi, HOST, PORT)
          ready.signal
        }
      }
    }

    mutex.synchronize {
      ready.wait(mutex)
      block.call
    }
  end

  class FakeGitHubApi < Sinatra::Base
    GITHUB_API_DIR = File.expand_path('../../fixtures/github_api', __FILE__)

    include JSONHelper

    before do
      content_type :json
    end

    get '/users/:user/repos' do
      respond_with_fixture("#{user}_repos.json") or pass
    end

    not_found do
      to_json(message: "Not Found")
    end

    private

    # Returns nil when the given fixture isn't found.
    def respond_with_fixture(filename)
      path = File.join(GITHUB_API_DIR, filename)
      File.read(path) if File.exists?(path)
    end

    def user
      params[:user]
    end
  end
end
