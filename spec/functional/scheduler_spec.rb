require 'spec_helper'

describe Khronos::Scheduler do
  subject { Khronos::Scheduler }
  let(:scheduler) { subject.new }

  before(:all) do
    ENV['KHRONOS_STORAGE'] = 'sqlite3://localhost/spec/tmp/scheduler.db'

    @storage = Khronos::Storage.new
    @storage.truncate!

    load_factory_girl!
    FactoryGirl.create(:schedule, :at => 1.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 5.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 10.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 30.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 60.minutes.from_now)
  end

  it "fetch schedules by time" do
    scheduler.fetch(1.minutes.from_now).length.should == 1
    scheduler.fetch(5.minutes.from_now).length.should == 2
    scheduler.fetch(10.minutes.from_now).length.should == 3
    scheduler.fetch(30.minutes.from_now).length.should == 4
    scheduler.fetch(60.minutes.from_now).length.should == 5
  end

end

