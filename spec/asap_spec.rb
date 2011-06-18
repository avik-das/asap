require 'spec_helper'

def url path
    "http://localhost:1234" + path
end

describe Asap do
  it 'should be a module' do
    Asap.class.should == Module
  end

  it 'should be callable as a function with a block' do
    lambda { Asap do; end }.should_not raise_error
  end

  it 'should require a block' do
    lambda { Asap() }.should raise_error
  end

  context 'given no gets' do
    it 'should have an empty result' do
      Asap do
      end.should == []
    end
  end

  context 'given one get' do
    it 'should return one result' do
      Asap do
        get url("/0/hello")
      end.should == ["hello"]
    end
  end

  context 'given two gets' do
    it 'should return two results' do
      Asap do
        get url("/0/hello")
        get url("/0/world")
      end.should == ["hello","world"]
    end
  end

  context 'given three gets' do
    it 'should return three results' do
      Asap do
        get url("/1/goodbye")
        get url("/1/cruel")
        get url("/1/world")
      end.should == ["goodbye","cruel","world"]
    end

    it 'should run in parallel' do
      start = Time.now
      Asap do
        get url("/1/goodbye")
        get url("/1/cruel")
        get url("/1/world")
      end
      (Time.now - start).should < 2
    end
  end

  context 'given one nested get' do
    it 'should return one nested result' do
      Asap do
        get url("/0/%2F0%2Fhello") do |resp|
          get url(resp)
        end
      end.should == [["/0/hello", ["hello"]]]
    end
  end

  context 'given two single-nested gets' do
    it 'should return two single-nested results' do
      Asap do
        get url("/0/%2F0%2Fhello") do |resp|
          get url(resp)
        end
        get url("/0/%2F0%2Fworld") do |resp|
          get url(resp)
        end
      end.should == [["/0/hello", ["hello"]], ["/0/world", ["world"]]]
    end
  end

  context 'given a combination of nested and flat gets' do
    it 'should return the same combination of nested and flat results' do
      Asap do
        get url("/0/hello0")
        get url("/0/%2F0%2Fhello1") do |resp|
          get url(resp)
        end
        get url("/0/world0")
        get url("/0/%2F0%2Fworld1") do |resp|
          get url(resp)
        end
      end.should == ["hello0",
        ["/0/hello1", ["hello1"]],
        "world0",
        ["/0/world1", ["world1"]]]
    end
  end

  context 'given deep nesting' do
    it 'should return a deeply-nested result' do
      Asap do
        get url("/0/%2F0%2F%252F0%252F%25252F0%25252Fhello") do |r1|
          get url(r1) do |r2|
            get url(r2) do |r3|
              get url(r3)
            end
          end
        end
      end.should ==
        [["/0/%2F0%2F%252F0%252Fhello", [
          ["/0/%2F0%2Fhello", [
            ["/0/hello", ["hello"]]]]]]]
    end
  end

  context 'given additional arguments' do
    it 'should pass the arguments to its block' do
      Asap("/0/hello") do |path|
        get url(path)
      end.should == ["hello"]
    end
  end

  context 'given a map over the gets' do
    it 'should behave like the gets are listed out' do
      Asap do
        (1..10).each do |i|
          get url("/1/#{i}")
        end
      end.should == (1..10).to_a.map(&:to_s)
    end

    it 'should behave like the gets are listed out' do
      start = Time.now
      Asap do
        (1..10).each do |i|
          get url("/1/#{i}")
        end
      end
      (Time.now - start).should < 2
    end
  end
end
