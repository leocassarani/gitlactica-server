require './lib/gitlactica/subscription'
require './lib/gitlactica/subscription_register'

module Gitlactica
  describe Gitlactica::SubscriptionRegister do
    let(:client) { mock(:client) }
    let(:repo) { mock(:repo) }
    let(:register) { SubscriptionRegister.new }

    describe "registering new subscriptions" do
      it "creates and returns a new subscription for a given client and repo" do
        subscription = register.subscribe(client, repo)
        subscription.should == Subscription.new(client, repo)
      end

      it "doesn't create new subscriptions if they already exist" do
        2.times { register.subscribe(client, repo) }
        register.clients_for_repo(repo).should have(1).client
      end
    end

    describe "#clients_for_repo" do
      let(:other_client) { mock(:other_client) }

      it "returns all clients subscribed to the given repo" do
        register.subscribe(client, repo)
        register.subscribe(other_client, repo)
        register.clients_for_repo(repo).should == [client, other_client]
      end

      it "yields all clients to a block, if given" do
        register.subscribe(client, repo)
        register.subscribe(other_client, repo)
        expect { |b|
          register.clients_for_repo(repo, &b)
        }.to yield_successive_args(client, other_client)
      end

      it "returns an empty array if no one is subscribed to the repo" do
        register.clients_for_repo(repo).should be_empty
      end
    end

    it "unsubscribes a given client from all repos" do
      register.subscribe(client, repo)
      register.unsubscribe(client)
      register.clients_for_repo(repo).should_not include(client)
    end
  end
end
