require 'gitlactica/subscription_register'

module Gitlactica
  describe Gitlactica::SubscriptionRegister do
    let(:client) { mock(:client) }
    let(:repo) { mock(:repo) }
    let(:register) { SubscriptionRegister.new }

    describe "subscribing clients to repos" do
      it "creates and returns a new subscription for a given client and repo" do
        register.subscribe(client, repo)
        register.clients_for_repo(repo).should == [client]
      end

      it "doesn't subscribe clients twice to the same repo" do
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

    describe "#repos_for_client" do
      let(:other_repo) { mock(:other_repo) }

      it "returns all repos that the given client is subscribed to" do
        register.subscribe(client, repo)
        register.subscribe(client, other_repo)
        register.repos_for_client(client).should == [repo, other_repo]
      end

      it "returns an empty array if the client isn't subscribed to any repos" do
        register.repos_for_client(client).should be_empty
      end
    end

    it "unsubscribes a given client from all repos" do
      register.subscribe(client, repo)
      register.unsubscribe(client)
      register.clients_for_repo(repo).should_not include(client)
    end
  end
end
