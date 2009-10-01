require "optparse"
require "pp"

# Options Parsing
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on("-o", "--operation [add|remove]", "Operation type") do |o|
    options[:operation] = o
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

shift_seconds = options[:time].match(/(\d+)/)[0].to_i
shift_ms = options[:time].match(/\d+,(\d+)/)[1].to_i

shift_value = shift_seconds * 1000 + shift_ms
puts options[:operation]
if options[:operation] == "remove"
  shift_value = shift_value * -1
end
puts shift_value

# Time Shifter
def shift_time(times, shift_value)
  newms = (times[2] * 1000) + times[3] + shift_value 
  array = [times[0], times[1], newms / 1000, newms % 1000]
  if array[2] >= 60
    div = array[2].divmod(60)
    array[1] = div[0] + array[1]
    array[2] = div[1]
  end
  if array[1] >= 60
    div = array[1].divmod(60)
    array[0] = div[0] + array[0]
    array[1] = div[1]
  end
  if array[2] < 0
    div = array[2].divmod 60
    array[1] = div[0] + array[1]
    array[2] = div[1]
  end
  if array[1] < 0
    div = array[1].divmod 60
    array[0] = div[0] + array[0]
    array[1] = div[1]
  end
  return array
end

def time_spliter(time)
  time = time.split(":")
  s_ms = time[2].split(",")
  time[2] = s_ms[0]
  time[3] = s_ms[1]
  time.map! {|n| n.to_i}
  return time
end

def time_mux(time)
  string = "%02d:%02d:%02d,%03d" % time
end

# File Operations
srtfile = IO.readlines(ARGV[0])
  
regex = Regexp.new(/\d+:\d+:\d+,\d+.*/)
  
srtfile.each do |line|
  if line.match(regex)
    times = line.match(/(\d+:\d+:\d+,\d+) --> (\d+:\d+:\d+,\d+)/)
    time_start = time_spliter(times[1])
    time_end = time_spliter(times[2])
    puts "Time Start: #{time_mux(time_start)} -> New TS: #{time_mux(shift_time(time_start, shift_value))}"
    #puts "Time End: #{time_mux(time_end)} -> New TE: #{time_mux(shift_time(time_end, shift_value))}"
  end
end
