require File.expand_path(File.join(File.dirname(__FILE__), "timecode"))

# Class for dealing with the actual subtitle file.
class Subshifter
  attr_accessor :filename, :infile, :outfile, :shift_value, :direction
  # Expects and option hash from OptParse
  # @param [Hash] OptParse hash.
  def initialize(options)
    @filename = options[:infile]
    @shift_value = options[:time]
    @direction = options[:direction]
    @infile = IO.readlines(@filename)
    outfile = options[:outfile]
    if File.exist?(outfile) && !options[:force]
      raise "Output file already exists"
    else
      puts "Creating #{outfile}" 
      @outfile = File.open(outfile, 'w')
    end
  end

  # Does the actual processing of the subtitle file
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
