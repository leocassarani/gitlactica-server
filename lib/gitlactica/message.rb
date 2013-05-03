module Gitlactica
  class Message
    class InvalidJSONError < StandardError ; end

    def self.from_json(json)
      msg = Yajl::Parser.parse(json, symbolize_keys: true)
      type = msg.fetch(:event, nil)
      data = msg.fetch(:data, {})
      new(type, data)
    rescue Yajl::ParseError => e
      raise InvalidJSONError.new(e.message)
    end

    attr_reader :type, :data

    def initialize(type, data)
      @type = type
      @data = data
    end
  end
end
