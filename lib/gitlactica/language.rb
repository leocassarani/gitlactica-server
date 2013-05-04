require_relative 'language/detector'
require_relative 'language/library'

module Gitlactica
  class Language
    class UnknownLanguage
      def self.name; "Unknown"; end
      def self.programming?; false; end
      def self.color; nil; end
    end

    class << self
      def for_extension(extension)
        return unknown if extension.empty?
        detector.detect(extension)
      end

      def with_name(name)
        return unknown if name.nil?
        library.with_name(name)
      end

      def unknown
        UnknownLanguage
      end

      def from_hash(name, hash)
        new(
          name: name,
          type: hash.fetch('type', nil),
          color: hash.fetch('color', nil)
        )
      end

      private

      def detector
        @detector ||= Language::Detector.new(languages, library)
      end

      def library
        @library ||= Language::Library.new(languages, self)
      end

      def languages
        @languages ||= Gitlactica::Config.languages
      end
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

    alias :eql? :==

    def hash
      name.hash
    end
  end
end
