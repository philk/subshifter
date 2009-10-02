require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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

describe Timecode, ".shift_time" do
  before(:each) do
    @timecode = Timecode.new("01:19:25,125")
    @timecode.shift = "20,150"
  end
  it "should work" do
    @timecode.shift.should == 20150
  end

  it "should return a new timecode" do
    @timecode.shift_time("forward").should be_an_instance_of Timecode
  end
  it "should shift the time" do
    @timecode.shift_time("forward").to_s.should == Timecode.new("01:19:45,275").to_s
  end
  it "should shift time backward" do
    @timecode.shift_time("backward").to_s.should == Timecode.new("01:19:04,975").to_s
  end
end

describe Timecode, ".negative?" do
  before(:each) do
    @timecode = Timecode.new("00:00:10:,125")
    @timecode.shift = "20,150"
  end
  it "should be negative" do
    code = @timecode.shift_time("backward")
    puts code
    code.negative?.should be_true
  end
  it "should be positive" do
    code = @timecode.shift_time("forward")
    puts code
    code.negative?.should be_false
  end
end
