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

      it "returns nil when given nil input" do
        User.from_commit(nil).should be_nil
      end
    end

    describe "mapping from a committer" do
      let(:json) { {
        'email' => "carl.whittaker@unboxedconsulting.com",
        'name' => "Carl Whittaker",
        'username' => "carlmw"
      } }

      let(:user) { User.from_committer(json) }
      subject { user }

      its(:login) { should == "carlmw" }

      it "returns nil when given nil input" do
        User.from_committer(nil).should be_nil
      end
    end

    it "is equal to users with the same login" do
      User.new("tcrayford").should == User.new("tcrayford")
    end
  end
end
