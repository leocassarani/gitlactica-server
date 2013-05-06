require 'securerandom'
require 'gitlactica/access_token'

module Gitlactica
  module Database; end

  describe Gitlactica::AccessToken do
    describe "make_nonce!" do
      let(:github_token) { 'github-token' }
      let(:nonce) { 'nonce' }

      before { Database.stub(:set_nonce) }
      before { SecureRandom.stub(:hex).with(20) { nonce } }

      it "returns a nonce" do
        AccessToken.make_nonce!(github_token).should == nonce
      end

      it "associates the nonce with the token in DB" do
        Database.should_receive(:set_nonce).with(nonce, github_token, 5 * 60)
        AccessToken.make_nonce!(github_token)
      end
    end

    describe "with_nonce" do
      let(:nonce) { 'nonce' }
      let(:github_token) { 'github-token' }

      before do
        Database.stub(:get_nonce).with(nonce) { github_token }
        Database.stub(:clear_nonce!)
      end

      it "creates a new instance using the github token in the DB" do
        Database.stub(:get_nonce).with(nonce) { github_token }
        token = AccessToken.with_nonce(nonce)
        token.github_token.should == github_token
      end

      it "clears the nonce stored in the DB" do
        Database.should_receive(:clear_nonce!).with(nonce)
        AccessToken.with_nonce(nonce)
      end
    end

    describe "make_user_token!" do
      let(:user_token) { 'user-token' }
      let(:github_token) { 'github-token' }

      before { Database.stub(:set_user_token) }
      before { SecureRandom.stub(:hex).with(20) { user_token } }

      it "creates a user token" do
        token = AccessToken.new(nil, github_token)
        token.make_user_token!
        token.user_token.should == user_token
      end

      it "does nothing if it already has a user token" do
        token = AccessToken.new('previous-user-token', 'github-token')
        token.make_user_token!
        token.user_token.should == 'previous-user-token'
      end

      it "associates the user token with the GitHub token in the DB" do
        Database.should_receive(:set_user_token).with(user_token, github_token)
        token = AccessToken.new(nil, github_token)
        token.make_user_token!
      end
    end
  end
end
