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
      files.inject({}) do |memo, file|
        language = language_for(file)
        deep_merge(memo, language.name, file)
      end
    end

    private

    def language_for(file)
      ext = File.extname(file)
      Language.for_extension(ext)
    end

    def deep_merge(memo, key, value)
      existing = memo.fetch(key, [])
      new = existing.push(value)
      memo.merge(key => new)
    end
  end
end
