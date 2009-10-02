require File.expand_path(File.dirname(__FILE__) + "/timecode.rb")

class Subshifter
  attr_accessor :filename, :file, :shift_value
  def initialize(filename, shift_value)
    @filename = filename
    @shift_value = shift_value
    @file = IO.readlines(@filename)
  end

  def write(outfile)

  end

  def process
    srtfile.each do |line|
      if line.match(regex)
        times = line.match(/(\d+:\d+:\d+,\d+) --> (\d+:\d+:\d+,\d+)/)
        time_start = Timecode.new(times[1])
        time_start.shift = shift_value
        new_start = time_start.shift_time(operation)
        unless new_start.negative?
          puts "Time Start: #{time_start.to_s} -> New TS: #{new_start}"
          time_end = Timecode.new(times[2])
          time_end.shift = shift_value
          new_end = time_end.shift_time(operation)
          puts "Time End: #{time_end.to_s} -> New TE: #{new_end}"
          return [new_start, new_end]
        end
      end
    end
  end
end
