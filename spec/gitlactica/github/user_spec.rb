require './lib/gitlactica/github/user'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::User do
    describe "mapping from a commit" do
      let(:json) { {
        'type'  => "User",
        'login' => "garybernhardt",
        "id" => 45707
      } }

      let(:user) { User.from_commit(json) }
      subject { user }

      its(:login) { should == "garybernhardt" }

      it "returns nil when given nil json input" do
        User.from_commit(nil).should be_nil
      end
    end

    it "is equal to users with the same login" do
      User.new("tcrayford").should == User.new("tcrayford")
    end
  end
end
