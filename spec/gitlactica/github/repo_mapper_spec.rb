require 'gitlactica/github/repo_mapper'

module Gitlactica
  class Language; end

  describe Gitlactica::GitHub::RepoMapper do
    let(:json) { {
      'full_name' => "igrigorik/em-websocket",
      'language' => "Ruby",
      'description' => "EventMachine based WebSocket server"
    } }

    let(:ruby) { mock(:ruby) }
    before { Language.stub(:with_name).with("Ruby") { ruby } }

    let(:klass) { Struct.new(:full_name, :language, :description) }
    let(:repo) { GitHub::RepoMapper.from_api(json, klass) }
    subject { repo }

    describe "attributes" do
      its(:language) { should == ruby }
      its(:description) { should == "EventMachine based WebSocket server" }
    end

    describe "full name" do
      context "when the payload has a full name attribute" do
        its(:full_name) { should == "igrigorik/em-websocket" }
      end

      context "when the payload has no full name, but has an owner" do
        before do
          json.delete('full_name')
          json.merge!(
            'name' => "em-websocket",
            'owner' => {
              'email' => "ilya@igvita.com",
              'name' => "igrigorik"
            }
          )
        end

        its(:full_name) { should == "igrigorik/em-websocket" }
      end
    end
  end
end
