class FakeGitHubApi < Sinatra::Base
  GITHUB_API_DIR = File.join(File.dirname(__FILE__), 'github_api')

  include JSONHelper

  before do
    content_type :json
  end

  get '/users/:user/repos' do
    respond_with_fixture("#{user}_repos.json") or pass
  end

  get '/repos/:user/:repo/commits' do
    respond_with_fixture("#{repo}_commits.json") or pass
  end

  get '/repos/:user/:repo/git/trees/master' do
    pass unless params.has_key?('recursive')
    respond_with_fixture("#{repo}_tree.json") or pass
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

  def repo
    params[:repo]
  end

  def user
    params[:user]
  end
end
