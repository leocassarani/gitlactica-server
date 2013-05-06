module GitHubApiHelper
  HOST = 'localhost'
  PORT = 3333

  def mock_github_api(&block)
    mutex = Mutex.new
    ready = ConditionVariable.new

    t = Thread.new {
      # Run Thin inside an EventMachine loop so calling start is non-blocking
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
      begin
        block.call
      rescue Exception => e
        t.terminate
        raise e
      end
    }
  end

  class FakeGitHubApi < Sinatra::Base
    GITHUB_API_DIR = File.expand_path('../../fixtures/github_api', __FILE__)

    include JSONHelper

    before do
      content_type :json
    end

    get '/users/:user/repos' do
      respond_with_fixture("#{param :user}_repos.json") or pass
    end

    post '/login/oauth/access_token' do
      pass unless param(:code) == "github-oauth-code"
      pass unless param(:client_id) == ENV['GITHUB_CLIENT_ID']
      pass unless param(:client_secret) == ENV['GITHUB_CLIENT_SECRET']
      pass unless request.accept?('application/json')
      to_json(
        access_token: "e72e16c7e42f292c6912e7710c838347ae178b4a",
        token_type: "bearer"
      )
    end

    not_found do
      to_json(error: "Not Found")
    end

    private

    # Returns nil when the given fixture isn't found.
    def respond_with_fixture(filename)
      path = File.join(GITHUB_API_DIR, filename)
      File.read(path) if File.exists?(path)
    end

    def param(key)
      key = String(key)
      params[key] unless params.fetch(key, '').empty?
    end
  end
end
