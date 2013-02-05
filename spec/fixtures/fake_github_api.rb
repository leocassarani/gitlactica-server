class FakeGitHubApi < Sinatra::Base
  get '/users/:user/repos' do
    content_type :json
    to_json(
      username: params[:user],
      repos: [
        {
          id: 1861402,
          name: "ace"
        },
        {
          id: 36,
          name: "ambition"
        }
      ]
    )
  end

  private

  def to_json(obj)
    Yajl::Encoder.encode(obj)
  end
end
