module JSONHelper
  def to_json(hash)
    Yajl::Encoder.encode(hash)
  end

  def from_json(json)
    Yajl::Parser.parse(json, symbolize_keys: true)
  end
end
