module Gitlactica
  class Language
    PROGRAMMING = %w(.c .cc .cpp .cxx .h .hs .java .js .m .php .pl .py .rb)

    def self.for_extension(extension)
      new(extension)
    end

    def initialize(extension)
      @extension = extension
    end

    def programming?
      PROGRAMMING.include?(@extension)
    end
  end
end
