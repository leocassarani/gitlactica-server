module Gitlactica
  class Message
    class InvalidJSONError < StandardError ; end

    attr_reader :msg

    def initialize(json)
      @msg = from_json(json)
    end

    def type
      return unless msg.is_a?(Hash)
      msg.fetch(:event, nil)
    end

    def data
      msg.fetch(:data, {})
    end

    private

    def from_json(json)
      Yajl::Parser.parse(json, symbolize_keys: true)
    rescue Yajl::ParseError => e
      raise InvalidJSONError.new(e.message)
    end
  end
end
