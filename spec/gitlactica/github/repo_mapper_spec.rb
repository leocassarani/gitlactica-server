require 'ostruct'
require './lib/gitlactica/github/repo_mapper'

describe Gitlactica::GitHub::RepoMapper do
  let(:json) { {
    'id' => 444184,
    'name' => "em-websocket",
    'description' => "EventMachine based WebSocket server"
  } }

  let(:repo) { Gitlactica::GitHub::RepoMapper.from_api(json, OpenStruct) }
  subject { repo }

  its(:id) { should == 444184 }
  its(:name)  { should == "em-websocket" }
  its(:description) { should == "EventMachine based WebSocket server" }
end
