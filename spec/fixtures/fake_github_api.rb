class FakeGitHubApi < Sinatra::Base
  GITHUB_API_DIR = File.join(File.dirname(__FILE__), 'github_api')

  get '/users/defunkt/repos' do
    content_type :json
    respond_with_fixture('defunkt_repos.json')
  end

  get '/repos/garybernhardt/raptor/commits' do
    content_type :json
    respond_with_fixture('raptor_commits.json')
  end

  private

  def respond_with_fixture(filename)
    path = File.join(GITHUB_API_DIR, filename)
    File.read(path)
  end
end
