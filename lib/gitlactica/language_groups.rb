module Gitlactica
  module LanguageGroups
    extend self

    # Public: Group the given Array of file paths by their detected language.
    #
    # files - The Array of file paths
    #
    # Examples
    #
    #   LanguageGroups.assign(["foo.rb", "bar.js", "qux.rb"])
    #   # => { 'Ruby' => ["foo.rb", "qux.rb"], 'JavaScript' => ["bar.js"] }
    #
    # Returns the Hash mapping languages to Arrays of files.
    def assign(files)
      files.group_by { |file| language_name(file) }
    end

    private

    def language_name(file)
      language_for(file).name
    end

    def language_for(file)
      ext = File.extname(file)
      Language.for_extension(ext)
    end
  end
end
