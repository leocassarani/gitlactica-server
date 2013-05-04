module AuthenticationHelper
  # Expects the top-level example group to have the format "GET /endpoint"
  def requires_authentication
    description = example.metadata[:example_group].fetch(:description_args, []).first
    fail "invalid example group description" unless description

    method, endpoint = description.split(' ')
    __send__(method.downcase, endpoint, access_token: '')
    last_response.status.should == 403
  end
end
