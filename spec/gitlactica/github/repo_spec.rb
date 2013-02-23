require './lib/gitlactica/github/repo'

module Gitlactica
  class Language; end

  describe Gitlactica::GitHub::Repo do
    let(:json) { {
      'name' => "em-websocket",
      'full_name' => "igrigorik/em-websocket",
      'language' => "Ruby",
      'description' => "EventMachine based WebSocket server"
    } }

    let(:ruby) { mock(:ruby) }
    before { Gitlactica::Language.stub(:with_name).with("Ruby") { ruby } }

    let(:repo) { GitHub::Repo.from_api(json) }
    subject { repo }

    its(:name)  { should == "em-websocket" }
    its(:full_name) { should == "igrigorik/em-websocket" }
    its(:language) { should == ruby }
    its(:description) { should == "EventMachine based WebSocket server" }

    describe "equality" do
      before { Gitlactica::Language.stub(:with_name) }

      it "is equal to a repository with the same full name" do
        GitHub::Repo.new(full_name: "technoweenie/faraday").should == GitHub::Repo.new(full_name: "technoweenie/faraday")
      end

      it "is different from repos with a different full name" do
        GitHub::Repo.new(full_name: "tcrayford/value").should_not == GitHub::Repo.new(full_name: "garybernhardt/value")
      end
    end
  end
end
