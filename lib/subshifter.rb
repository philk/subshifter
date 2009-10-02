class Subshifter
  attr_accessor :shift_time, :shift_type 

  def initialize(shift_time, shift_type, srtfile)
    @shift_time = shift_time
    @shift_type = shift_type 
    @srtfile = srtfile
    sms = @shift_time.split(",")
    @shift_integer = sms[0] * 60 + sms[1]
  end

  def to_ms
    
  end

  def time_shift(timecode)
    newms = @shift_integer + timecode
  end

  def time_demux(time)
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

end
