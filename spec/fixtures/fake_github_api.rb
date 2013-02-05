class FakeGitHubApi < Sinatra::Base
  GITHUB_API_DIR = File.join(File.dirname(__FILE__), 'github_api')

  get '/users/:user/repos' do
    content_type :json
    respond_with_fixture('repos.json')
  end

  private

  def respond_with_fixture(filename)
    path = File.join(GITHUB_API_DIR, filename)
    File.read(path)
  end
end
