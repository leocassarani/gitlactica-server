require './lib/gitlactica/github/blob'

module Gitlactica::GitHub
  describe Gitlactica::GitHub::Blob do
    describe "mapping from JSON" do
      let(:json) { {
        'mode' => "100644",
        'type' => "blob",
        'sha' => "f919c19b635f229dd09b37430d2bdba04d9de0fd",
        'path' => "lib/raptor.rb",
        'size' => 1830,
        'url' => "https://api.github.com/repos/garybernhardt/raptor/git/blobs/f919c19b635f229dd09b37430d2bdba04d9de0fd"
      } }

      let(:blob) { Blob.from_api(json) }
      subject { blob }

      its(:path) { should == "lib/raptor.rb" }
      its(:sha)  { should == "f919c19b635f229dd09b37430d2bdba04d9de0fd" }
      its(:size) { should == 1830 }
    end

    describe "extension" do
      def blob(path)
        Blob.new(
          sha: "f919c19b635f229dd09b37430d2bdba04d9de0fd",
          path: path
        )
      end

      it "returns the file extension when there is one" do
        blob('lib/raptor.rb').extension.should == '.rb'
      end

      it "only returns the last component of a multi-part extension" do
        blob('index.html.erb').extension.should == '.erb'
      end

      it "returns an empty string for extensionless filenames" do
        blob('Gemfile').extension.should be_empty
      end

      it "isn't confused by hidden files" do
        blob('example/.rvmrc').extension.should be_empty
      end
    end

    describe "equality" do
      it "is equal to another blob with the same SHA" do
        Blob.new(sha: "123abc").should == Blob.new(sha: "123abc")
      end

      it "is different from blobs with different SHA" do
        Blob.new(sha: "123abc", path: "Gemfile").should_not == Blob.new(sha: "cba321", path: "Gemfile")
      end
    end
  end
end
