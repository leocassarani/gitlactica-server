require './lib/gitlactica/github/user'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::User do
    let(:json) { {
      'type'  => "User",
      'login' => "garybernhardt"
    } }

    let(:user) { User.from_api(json) }
    subject { user }

    its(:login) { should == "garybernhardt" }

    it "is equal to users with the same login" do
      User.new("tcrayford").should == User.new("tcrayford")
    end
  end
end
