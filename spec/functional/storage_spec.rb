require 'spec_helper'

describe Khronos::Storage do
  subject { Khronos::Storage::Schedule }
  let(:schedule) { subject }

  before(:all) do
    ENV['KHRONOS_STORAGE'] = 'postgresql://localhost:5432/khronos'

    @storage = Khronos::Storage.new
    @storage.truncate!

    load_factory_girl!
  end

  it "fetch schedules by time" do
    FactoryGirl.create(:schedule, :at => 1.minutes.from_now)
    schedule.fetch(1.minutes.from_now).length.should == 1

    FactoryGirl.create(:schedule, :at => 1.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 5.minutes.from_now)
    schedule.fetch(5.minutes.from_now).length.should == 2

    FactoryGirl.create(:schedule, :at => 1.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 5.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 10.minutes.from_now)
    schedule.fetch(10.minutes.from_now).length.should == 3

    FactoryGirl.create(:schedule, :at => 1.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 5.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 10.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 30.minutes.from_now)
    schedule.fetch(30.minutes.from_now).length.should == 4

    FactoryGirl.create(:schedule, :at => 1.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 5.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 10.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 30.minutes.from_now)
    FactoryGirl.create(:schedule, :at => 60.minutes.from_now)
    schedule.fetch(60.minutes.from_now).length.should == 5

    schedule.fetch(60.minutes.from_now).length.should == 0
  end

end

