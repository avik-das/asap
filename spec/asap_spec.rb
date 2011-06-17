require 'spec_helper'

describe Asap do
  it 'should be a module' do
    Asap.class.should == Module
  end

  it 'should be callable as a function' do
    lambda { Asap() }.should_not raise_error
  end
end
