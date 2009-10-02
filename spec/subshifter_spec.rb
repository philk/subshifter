require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Subshifter do
  before(:all) do
    @sub = Subshifter.new("samples/himym205.srt", "10,105")
  end

  it do
    @sub.should be_true
  end

  it "should have a filename" do
    @sub.filename.should == "samples/himym205.srt"
  end

  it "should have a shift_value" do
    @sub.shift_value.should == "10,105"
  end

  it "should have lines" do
    @sub.file.should_not be_false
  end

  it "should write a file" do
    @sub.write be_true
  end
end
