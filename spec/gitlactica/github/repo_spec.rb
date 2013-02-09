require './lib/gitlactica/github/repo'

describe Gitlactica::GitHub::Repo do
  let(:json) { {
    'name' => "em-websocket",
    'full_name' => "igrigorik/em-websocket",
    'language' => "Ruby",
    'description' => "EventMachine based WebSocket server"
  } }

  let(:repo) { Gitlactica::GitHub::Repo.from_api(json) }
  subject { repo }

  its(:name)  { should == "em-websocket" }
  its(:full_name)  { should == "igrigorik/em-websocket" }
  its(:language) { should == "Ruby" }
  its(:description) { should == "EventMachine based WebSocket server" }
end
