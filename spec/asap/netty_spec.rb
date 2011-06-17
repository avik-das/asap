require 'spec_helper'

describe Asap::Netty, '.get' do
  it 'fetches the specified resource and invokes the callback with it' do
    semaphore = java.util.concurrent.Semaphore.new(0)
    result = nil
    Asap::Netty.get("http://localhost:1234/0/hello") do |data|
      result = data
      semaphore.release
    end
    semaphore.acquire
    result.should == 'hello'
  end
end
