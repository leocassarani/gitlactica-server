require 'ostruct'
require './lib/gitlactica/github/commit_mapper'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::CommitMapper do
    before { stub_const('Gitlactica::GitHub::User', Class.new) }

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
  end
end
