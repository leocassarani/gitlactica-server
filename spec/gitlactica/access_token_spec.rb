require 'securerandom'
require 'gitlactica/access_token'

module Gitlactica
  module Database; end

  describe Gitlactica::AccessToken do
    describe "make_nonce!" do
      let(:access_token) { 'accesstoken' }
      let(:nonce) { 'nonce' }

      before { Database.stub(:set_nonce) }
      before { SecureRandom.stub(:hex).with(20) { nonce } }

      it "returns a nonce" do
        AccessToken.make_nonce!(access_token).should == nonce
      end

      it "associates the nonce with the token in DB" do
        Database.should_receive(:set_nonce).with(nonce, access_token, 5 * 60)
        AccessToken.make_nonce!(access_token)
      end
    end
  end
end
