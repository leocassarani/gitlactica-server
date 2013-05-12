require 'securerandom'
require './spec/support/redis_helper'
require 'gitlactica/db'
require 'gitlactica/db/nonce'

module Gitlactica
  describe Gitlactica::DB::Nonce do
    let(:redis) { DB.redis }
    before { SecureRandom.stub(:hex) { "a-nonce" } }

    it "creates a new nonce for the given token in Redis" do
      DB::Nonce.create("super-secret-token")
      redis.get("nonce:a-nonce").should == "super-secret-token"
    end

    it "it retrieves saved nonces" do
      redis.set("nonce:another-nonce", "super-secret-token")
      nonce = DB::Nonce.find("another-nonce")
      nonce.token.should == "super-secret-token"
    end

    it "destroys existing nonces" do
      nonce = DB::Nonce.create("super-secret-token")
      nonce.destroy!
      redis.get("nonce:a-nonce").should be_nil
    end
  end
end
