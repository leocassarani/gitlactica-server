require 'ostruct'
require 'gitlactica/github/commit_mapper'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::CommitMapper do
    before { stub_const('Gitlactica::GitHub::User', Class.new) }
    before { stub_const('Gitlactica::GitHub::Changes', Class.new) }

    describe "mapping from a commit object" do
      let(:json) { {
        'sha' => "0495181f0fd54630717773bbc2e60a6a04667389",
        'commit' => {
          'committer' => {
            'name' => "Carl Whittaker",
            'email' => "carl.whittaker@unboxedconsulting.com",
            'date' => "2012-10-31T17:50:48Z"
          },
        },
        'committer' => {
          'login' => "carlmw",
          'id' => 122096,
          'type' => "User"
        }
      } }

      let(:user) { mock(:user) }
      before do
        User.stub(:from_commit).with(
          'login' => "carlmw",
          'id' => 122096,
          'type' => "User"
        ) { user }
      end

      let(:commit) { CommitMapper.from_repo(json, OpenStruct) }
      subject { commit }

      its(:sha) { should == "0495181f0fd54630717773bbc2e60a6a04667389" }
      its(:committer) { should == user }
      its(:date) { should == "2012-10-31T17:50:48Z" }
    end

    describe "mapping from a push event" do
      let(:json) { {
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

      let(:user) { mock(:user) }
      before do
        User.stub(:from_committer).with(
          'email' => "carl.whittaker@unboxedconsulting.com",
          'name' => "Carl Whittaker",
          'username' => "carlmw"
        ) { user }
      end

      let(:changes) { mock(:changes) }
      before do
        Changes.stub(:from_api).with(json) { changes }
      end

      let(:commit) { CommitMapper.from_push_event(json, OpenStruct) }
      subject { commit }

      its(:sha) { should == "612ea64cf18c5200a6128b1cdf379031fe8aa69e" }
      its(:committer) { should == user }
      its(:date) { should == "2013-02-20T09:38:41-08:00" }
      its(:changes) { should == changes }
    end
  end
end
