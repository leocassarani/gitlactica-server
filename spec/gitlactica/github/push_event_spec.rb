require './lib/gitlactica/github/push_event'

module Gitlactica::GitHub
  class Commit; end
  class Repo; end

  describe Gitlactica::GitHub::PushEvent do
    describe "creating an instance from a webhook payload" do
      let(:json_commit) { {
        'added' => [
          "lib/subspace_channel.js",
          "test/system.js",
        ],
        'author' => {
          'email' => "carl.whittaker@unboxedconsulting.com",
          'name' => "Carl Whittaker",
          'username' => "carlmw"
        },
        'committer' => {
          'email' => "carl.whittaker@unboxedconsulting.com",
          'name' => "Carl Whittaker",
          'username' => "carlmw"
        },
        'id' => "612ea64cf18c5200a6128b1cdf379031fe8aa69e",
        'modified' => [
          "lib/orbit_allocator.js",
          "test/orbit_allocator.js"
        ],
        'removed' => [
          "lib/derp.js"
        ],
        'timestamp' => "2013-02-20T09:38:41-08:00"
      } }

      let(:json_repo) { {
        'description' => "Stuff",
        'language' => "JavaScript",
        'name' => "gitlactica",
        'owner' => {
          'email' => "carl359@gmail.com",
          'name' => "carlmw"
        }
      } }

      let(:json) { {
        'after' => "612ea64cf18c5200a6128b1cdf379031fe8aa69e",
        'before' => "187066bad3609058c719f3e7a30a255430e7ae59",
        'commits' => [json_commit],
        'repository' => json_repo
      } }

      let(:repo) { mock(:repo) }
      before { Repo.stub(:from_api).with(json_repo) { repo } }

      let(:commit) { mock(:commit) }
      before { Commit.stub(:from_push_event).with(json_commit) { commit } }

      let(:event) { PushEvent.from_api(json) }
      subject { event }

      its(:repo) { should == repo }
      its(:commits) { should == [commit] }
    end
  end
end
