require 'spec_helper'

describe Asap::Netty, '.get' do
  it 'fetches the specified resource' do
    Asap::Netty.get("http://localhost:1234/0/hello").should == "hello"
  end
end
