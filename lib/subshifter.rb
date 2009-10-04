require File.expand_path(File.dirname(__FILE__) + "/timecode.rb")

class Subshifter
  attr_accessor :filename, :infile, :outfile, :shift_value, :direction
  def initialize(options)
    @filename = options[:infile]
    @shift_value = options[:time]
    @direction = options[:direction]
    @infile = IO.readlines(@filename)
    outfile = options[:outfile]
    if File.exist?(outfile) && !options[:force]
      raise "Output file already exists"
    else
      puts "file doesn't exist"
      @outfile = File.open(outfile, 'w')
    end
  end

  def process
    regex = Regexp.new(/\d+:\d+:\d+,\d+.*/)
    @infile.each do |line|
      if line.match(regex)
        times = line.match(/(\d+:\d+:\d+,\d+) --> (\d+:\d+:\d+,\d+)/)
        time_start = Timecode.new(times[1])
        time_start.shift = @shift_value
        new_start = time_start.shift_time(@direction)
        unless new_start.negative?
#          puts "Time Start: #{time_start.to_s} -> New TS: #{new_start}"
          time_end = Timecode.new(times[2])
          time_end.shift = @shift_value
          new_end = time_end.shift_time(@direction)
#          puts "Time End: #{time_end.to_s} -> New TE: #{new_end}"
          @outfile.write("#{new_start} --> #{new_end}\r\n")
        end
      else
        @outfile.write(line)
      end
    end
  end
end
