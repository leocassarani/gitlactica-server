require './lib/gitlactica/github/repo_mapper'
require './lib/gitlactica/github/repo'
require './lib/gitlactica/github/user'
require './lib/gitlactica/github/commit_mapper'
require './lib/gitlactica/github/commit'
require './lib/gitlactica/github/push_event'

module Gitlactica
  class Language; end

  describe Gitlactica::GitHub::PushEvent do
    describe "creating an instance from a webhook payload" do
      let(:json) { {
        'after' => "612ea64cf18c5200a6128b1cdf379031fe8aa69e",
        'before' => "187066bad3609058c719f3e7a30a255430e7ae59",
        'commits' => [
          {
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
          }
        ],
        'repository' => {
          'description' => "Stuff",
          'language' => "JavaScript",
          'name' => "gitlactica",
          'owner' => {
            'email' => "carl359@gmail.com",
            'name' => "carlmw"
          }
        }
      } }

      let(:javascript) { mock(:javascript) }
      before { Language.stub(:with_name).with("JavaScript") { javascript } }

      let(:event) { GitHub::PushEvent.from_api(json) }

      describe "mapping the repo" do
        subject { event.repo }

        its(:full_name) { should == "carlmw/gitlactica" }
        its(:name) { should == "gitlactica" }
        its(:language) { should == javascript }
        its(:description) { should == "Stuff" }
      end

      describe "mapping the commits" do
        let(:commit) { event.commits.first }
        subject { commit }

        its(:sha) { should == "612ea64cf18c5200a6128b1cdf379031fe8aa69e" }
        its(:committer) { should == GitHub::User.new('carlmw') }
        its(:date) { should == "2013-02-20T09:38:41-08:00" }

        it "maps all commits" do
          event.commits.should == [
            GitHub::Commit.new(sha: "612ea64cf18c5200a6128b1cdf379031fe8aa69e")
          ]
        end
      end
    end
  end
end
