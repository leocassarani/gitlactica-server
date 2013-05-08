module GitHubApiHelper
  HOST = 'localhost'
  PORT = 3333

  def mock_github_api(&block)
    mutex = Mutex.new
    ready = ConditionVariable.new

    t = Thread.new {
      # Run Thin inside an EventMachine loop so starting it is non-blocking
      EM.run {
        mutex.synchronize {
          Thin::Logging.silent = true
          Thin::Server.start(FakeGitHubApi, HOST, PORT)
          ready.signal
        }
      }
    }

    # Wait until the server is up and running, then execute the block
    mutex.synchronize {
      ready.wait(mutex)
      begin
        block.call
      rescue Exception => e
        raise e
      ensure
        t.terminate
      end
    }
  end

  class FakeGitHubApi < Sinatra::Base
    ACCESS_TOKEN   = 'github-access-token'
    GITHUB_API_DIR = File.expand_path('../../fixtures/github_api', __FILE__)

    include JSONHelper

    before do
      content_type :json
    end

    get '/user/repos' do
      require_access_token
      respond_with_fixture("#{current_user}_repos.json") or pass
    end

    post '/login/oauth/access_token' do
      pass unless param(:code) == "github-oauth-code"
      pass unless param(:client_id) == ENV['GITHUB_CLIENT_ID']
      pass unless param(:client_secret) == ENV['GITHUB_CLIENT_SECRET']
      pass unless request.accept.any? { |t| File.fnmatch('application/json', t) } # this is nuts

      to_json(
        access_token: "e72e16c7e42f292c6912e7710c838347ae178b4a",
        token_type: "bearer"
      )
    end

    not_found do
      to_json(error: "Not Found")
    end

    private

    def require_access_token
      pass unless env['HTTP_AUTHORIZATION'] == "token #{ACCESS_TOKEN}"
    end

    # Returns nil when the given fixture isn't found.
    def respond_with_fixture(filename)
      path = File.join(GITHUB_API_DIR, filename)
      File.read(path) if File.exists?(path)
    end

    def param(key)
      key = String(key)
      params[key] unless params.fetch(key, '').empty?
    end

    def current_user
      'celluloid' # Why not
    end
  end
end
