require "optparse"
require "pp"
require 'lib/timecode.rb'

# Options Parsing
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on("-o", "--operation [add|remove]", "Operation type") do |o|
    if o == "add"
      options[:operation] = "forward"
    elsif o == "remove"
      options[:operation] = "backward"
    end
  end

  opts.on("-t", "--time [seconds],[milliseconds]", "Time shift in format: seconds,milliseconds") do |t|
    if t =~ /\d+,\d+/
      options[:time] = t
    else
      puts "#{t.methods.sort} is not valid.  Must be of format seconds,milliseconds to shift timecode by."
    end
  end

  opts.on_tail("-?", "-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

operation = options[:operation]
shift_value = options[:time]

# File Operations
srtfile = IO.readlines(ARGV[0])
  
regex = Regexp.new(/\d+:\d+:\d+,\d+.*/)
  
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
    end
  end
end
