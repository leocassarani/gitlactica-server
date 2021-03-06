require 'yajl'
require 'gitlactica/message'

describe Gitlactica::Message do
  it "raises an error when given invalid JSON" do
    expect {
      Gitlactica::Message.from_json("not actually JSON lol")
    }.to raise_error(Gitlactica::Message::InvalidJSONError)
  end
end
