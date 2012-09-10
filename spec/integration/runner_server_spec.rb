require 'spec_helper'

describe Khronos::Server::Runner do
  subject { Khronos::Server::Runner }
  let(:recurrency_check_url) { "http://localhost:8080/task" }
  let(:task_url) { 'http://test.com' }

  before(:each) do

    stub_request(:get, task_url).to_return(:body => 'it works!', :status => 200)
    stub_request(:put, recurrency_check_url).with(:id => 1, :patch => true).to_return(:status => 200, :body => "", :headers => {})
  end

  it "should run a task" do
    runner = subject.new(nil)
    runner.process({:id => 1, :task_url => task_url, :recurrency => 0}.to_json)
    runner.process({:id => 1, :task_url => task_url, :recurrency => 60}.to_json)

    a_request(:get, task_url).should have_been_made.times(2)
    a_request(:put, recurrency_check_url).should have_been_made
  end

end
