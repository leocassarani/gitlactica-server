require './lib/gitlactica/language'

module Gitlactica
  module Config; end

  describe Gitlactica::Language do
    it "knows when it's a programming language" do
      Language.new(name: "Ruby", type: 'programming').should be_programming
    end

    it "knows when it's not a programming language" do
      Language.new(name: "HTML", type: 'markup').should_not be_programming
      Language.new(name: "Brainfuck").should_not be_programming
    end
  end
end
