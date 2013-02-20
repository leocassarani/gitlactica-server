require './lib/gitlactica/github/user'
require './lib/gitlactica/github/commit'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::Commit do
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

    let(:commit) { Commit.from_api(json) }
    subject { commit }

    its(:committer) { should == User.new('carlmw') }
    its(:date) { should == "2012-10-31T17:50:48Z" }
  end
end
