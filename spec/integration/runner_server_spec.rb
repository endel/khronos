require 'spec_helper'

describe Khronos::Server::Runner do
  subject { Khronos::Server::Runner }

  it "should run a task" do
    runner = subject.new
    runner.receive_data('{"id" : 1, "task_url" : "http://test.com", "recurring" : 0}')
  end

end
