require './spec/support/redis_helper'
require 'securerandom'
require 'gitlactica/db'
require 'gitlactica/db/user_token'

module Gitlactica
  describe Gitlactica::DB::UserToken do
    let(:redis) { DB.redis }
    before { SecureRandom.stub(:hex) { "a-user-token" } }

    it "creates a user token for the given github token in Redis" do
      DB::UserToken.create("github-token")
      redis.get("user_token:a-user-token").should == "github-token"
    end

    it "retrieves existing user tokens from Redis" do
      redis.set("user_token:another-user-token", "github-token")
      token = DB::UserToken.find("another-user-token")
      token.github_token.should == "github-token"
    end
  end
end
