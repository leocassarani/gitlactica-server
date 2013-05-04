module JSONHelper
  def from_json(json)
    Yajl::Parser.parse(json, symbolize_keys: true)
  end

  def to_json(obj)
    Yajl::Encoder.encode(obj)
  end

  def json_response
    from_json(last_response.body)
  end
end
