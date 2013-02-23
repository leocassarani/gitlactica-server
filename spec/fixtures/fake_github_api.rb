class FakeGitHubApi < Sinatra::Base
  GITHUB_API_DIR = File.join(File.dirname(__FILE__), 'github_api')

  include JSONHelper

  before do
    content_type :json
  end

  get '/users/defunkt/repos' do
    respond_with_fixture('defunkt_repos.json')
  end

  get '/repos/garybernhardt/raptor/commits' do
    respond_with_fixture('raptor_commits.json')
  end

  get '/repos/carlmw/gitlactica/commits' do
    respond_with_fixture('gitlactica_commits.json')
  end

  get '/repos/garybernhardt/raptor/git/trees/master' do
    pass unless params.has_key?('recursive')
    respond_with_fixture('raptor_tree.json')
  end

  get '/repos/carlmw/gitlactica/git/trees/master' do
    pass unless params.has_key?('recursive')
    respond_with_fixture('gitlactica_tree.json')
  end

  not_found do
    to_json(message: "Not Found")
  end

  private

  def respond_with_fixture(filename)
    path = File.join(GITHUB_API_DIR, filename)
    File.read(path)
  end
end
