module Gitlactica
  FileList = Struct.new(:files) do
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

    private

    def language_for(file)
      ext = File.extname(file)
      Language.for_extension(ext)
    end
  end
end
