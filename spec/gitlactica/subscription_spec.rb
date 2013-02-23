require './lib/gitlactica/subscription'

module Gitlactica
  describe Gitlactica::Subscription do
    describe "equality" do
      let(:client) { mock(:client) }
      let(:repo) { mock(:repo) }

      it "is equal to a subscription with same client and repo" do
        Subscription.new(client, repo).should == Subscription.new(client, repo)
      end

      it "is different from a subscription with same client but different repo" do
        other_repo = mock(:other_repo)
        Subscription.new(client, repo).should_not == Subscription.new(client, other_repo)
      end

      it "is different from a subscription with same repo but different client" do
        other_client = mock(:other_client)
        Subscription.new(client, repo).should_not == Subscription.new(other_client, repo)
      end

      it "is different from a subscription with different client and repo" do
        other_client = mock(:other_client)
        other_repo = mock(:other_repo)
        Subscription.new(client, repo).should_not == Subscription.new(other_client, other_repo)
      end
    end
  end
end
