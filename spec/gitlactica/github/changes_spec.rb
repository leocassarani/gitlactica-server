require './lib/gitlactica/github/changes'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::Changes do
    describe "mapping from the API" do
      let(:json) { {
          'added' => [
            "lib/subspace_channel.js",
            "test/system.js",
          ],
          'modified' => [
            "lib/orbit_allocator.js",
            "test/orbit_allocator.js"
          ],
          'removed' => [
            "lib/derp.js"
          ]
      } }

      let(:changes) { Changes.from_api(json) }
      subject { changes }

      it "maps the files that were added" do
        changes.added.should == [
          "lib/subspace_channel.js",
          "test/system.js"
        ]
      end

      it "maps the files that were modified" do
        changes.modified.should == [
          "lib/orbit_allocator.js",
          "test/orbit_allocator.js"
        ]
      end

      it "maps the files that were removed" do
        changes.removed.should == ["lib/derp.js"]
      end
    end

    it "returns the number of added files" do
      changes = Changes.new(added: ["one", "test/two"])
      changes.added_count.should == 2
    end

    it "returns the number of modified files" do
      changes = Changes.new(modified: ["one", "test/two", "lib/three"])
      changes.modified_count.should == 3
    end

    it "returns the number of removed files" do
      changes = Changes.new(removed: ["one"])
      changes.removed_count.should == 1
    end
  end
end
