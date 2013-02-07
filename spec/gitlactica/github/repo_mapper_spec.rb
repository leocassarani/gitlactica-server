require 'ostruct'
require './lib/gitlactica/github/repo_mapper'

describe Gitlactica::GitHub::RepoMapper do
  let(:json) { {
    'name' => "em-websocket",
    'full_name' => "igrigorik/em-websocket",
    'description' => "EventMachine based WebSocket server"
  } }

  let(:repo) { Gitlactica::GitHub::RepoMapper.from_api(json, OpenStruct) }
  subject { repo }

  its(:name)  { should == "em-websocket" }
  its(:full_name)  { should == "igrigorik/em-websocket" }
  its(:description) { should == "EventMachine based WebSocket server" }
end
