require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))


describe Subshifter do
  before(:all) do
    @samplein = File.expand_path(File.join(File.dirname(__FILE__), "..", "samples", "SurfsUp.srt"))
    @sampleout = File.expand_path(File.join(File.dirname(__FILE__), "..", "samples", "SurfsUp-shifted.srt"))
    options = {:infile => @samplein, :time => "10,105", :outfile => @sampleout, :force => true}
    @sub = Subshifter.new(options)
  end

  it do
    @sub.should be_true
  end

  it "should have a filename" do
    @sub.filename.should == @samplein
  end

  it "should have a shift_value" do
    @sub.shift_value.should == "10,105"
  end

  it "should have lines" do
    @sub.infile.should_not be_false
  end

  it "should write a file" do
    @sub.outfile.should be_true
  end
end
