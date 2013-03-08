module Gitlactica
  class FileList
    attr_reader :files

    def initialize(files)
      @files = files
    end

    # Public: Group the Array of file paths by their detected language.
    #
    # Examples
    #
    #   list = FileList.new(["foo.rb", "bar.js", "qux.rb"])
    #   list.group_by_language
    #   # => { 'Ruby' => ["foo.rb", "qux.rb"], 'JavaScript' => ["bar.js"] }
    #
    # Returns the Hash mapping languages to Arrays of files.
    def group_by_language
      files.group_by { |file| language_for(file).name }
    end

    # Equality

    def ==(obj)
      obj.is_a?(self.class) && obj.files == files
    end

    alias :eql? :==

    def hash
      files.hash
    end

    private

    def language_for(file)
      ext = File.extname(file)
      Language.for_extension(ext)
    end
  end
end
