require File.dirname(__FILE__) + '/../lib/timecode.rb'

describe Timecode do
  before(:all) do
    @timecode = Timecode.new("01:19:25,125")
  end
  it "should have hours" do
    @timecode.hours.should == 1
  end
  it "should have minutes" do
    @timecode.minutes.should == 19
  end
  it "should have seconds" do
    @timecode.seconds.should == 25
  end
  it "should have milliseconds" do
    @timecode.milliseconds.should == 125
  end

  it "should convert to an array" do
    @timecode.to_array == [1, 19, 25, 125]
  end
  it "should convert to a string" do
    @timecode.to_s == "01:19:25,125"
  end
  
end

describe Timecode, ".shift_calc" do
  before(:all) do
    @timecode = Timecode.new("01:19:25,125")
  end
  it "should return an integer" do
    @timecode.shift_calc("20,150").should == 20150
  end
end

describe Timecode, ".shift" do
  before(:each) do
    @timecode = Timecode.new("01:19:25,125")
  end
  it "should work" do
    @timecode.shift = "20,150"
    @timecode.shift.should == 20150
  end

  it "should return a new timecode" do
    @timecode.shift_forward("20,150").should be_an_instance_of Timecode
  end
  it "should shift the time" do
    @timecode.shift_forward("20,150").to_s.should == Timecode.new("01:19:45,275").to_s
  end
  it "should shift time backward" do
    @timecode.shift_backward("50,300").to_s.should == Timecode.new("01:18:34,825").to_s
  end
end
