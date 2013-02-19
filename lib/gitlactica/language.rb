module Gitlactica
  class Language
    class UnknownLanguage
      def self.programming?; false; end
    end

    def self.for_extension(extension)
      return UnknownLanguage if extension.empty?
      @detector ||= LanguageDetector.new(Config.languages)
      @detector.detect(extension)
    end

    def self.from_hash(name, hash)
      new(
        name: name,
        type: hash.fetch('type', nil),
        color: hash.fetch('color', nil)
      )
    end

    attr_reader :name, :color, :type

    def initialize(attr = {})
      @name  = attr.fetch(:name)
      @type  = attr.fetch(:type, nil)
      @color = attr.fetch(:color, nil)
    end

    def programming?
      type == 'programming'
    end

    def ==(obj)
      obj.is_a?(self.class) &&
        obj.name == name &&
        obj.color == color &&
        obj.type == type
    end

    def hash
      name.hash
    end
  end
end
