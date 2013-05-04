module RackIntegrationHelper
  include Rack::Test::Methods

  def app
    Gitlactica::Api::App.new
  end
end
