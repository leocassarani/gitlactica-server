require 'gitlactica/file_list'
require 'gitlactica/github/changes'

module Gitlactica
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

      let(:changes) { GitHub::Changes.from_api(json) }
      subject { changes }

      it "maps the files that were added" do
        changes.added.should == FileList.new([
          "lib/subspace_channel.js",
          "test/system.js"
        ])
      end

      it "maps the files that were modified" do
        changes.modified.should == FileList.new([
          "lib/orbit_allocator.js",
          "test/orbit_allocator.js"
        ])
      end

      it "maps the files that were removed" do
        changes.removed.should == FileList.new(["lib/derp.js"])
      end
    end
  end
end
