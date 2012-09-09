require 'spec_helper'

describe Khronos do
  it "should idenfity Khronos::VERSION" do
    Khronos::VERSION.should be_a_kind_of String
  end
end
