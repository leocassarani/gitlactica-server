require './lib/gitlactica/github/user'

describe Gitlactica::GitHub::User do
  let(:json) { {
    'type'  => "User",
    'login' => "garybernhardt"
  } }

  let(:user) { Gitlactica::GitHub::User.from_api(json) }
  subject { user }

  its(:login) { should == "garybernhardt" }
end
