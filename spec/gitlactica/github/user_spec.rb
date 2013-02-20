require './lib/gitlactica/github/user'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::User do
    describe "creating an instance from an API response" do
      let(:json) { {
        'type'  => "User",
        'login' => "garybernhardt"
      } }

      let(:user) { User.from_api(json) }
      subject { user }

      its(:login) { should == "garybernhardt" }

      it "returns nil when given nil json input" do
        User.from_api(nil).should be_nil
      end
    end

    it "is equal to users with the same login" do
      User.new("tcrayford").should == User.new("tcrayford")
    end
  end
end
