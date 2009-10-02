class Timecode
  attr_accessor :hours, :minutes, :seconds, :milliseconds, :shift
  def initialize(timecode)
    @timecode = timecode
    if @timecode.is_a?(String)
      @time_array = self.to_array
    elsif @timecode.is_a?(Array)
      @time_array = @timecode
      @timecode = self.to_s
    end
    @hours = @time_array[0]
    @minutes = @time_array[1]
    @seconds = @time_array[2]
    @milliseconds = @time_array[3]
  end

  def to_array
    colon_split = @timecode.split(":") 
    comma_split = colon_split[2].split(",")
    time_array = [colon_split[0], colon_split[1], comma_split[0], comma_split[1]]
    time_array.map! {|a| a.to_i}
  end

  def to_s
    string = "%02d:%02d:%02d,%03d" % @time_array
  end

  def shift=(shift)
    @shift = shift_calc(shift)
  end

  def shift_calc(shift_value)
    shift_split = shift_value.split(",")
    shift_split.map! {|a| a.to_i}
    shift = (shift_split[0] * 1000) + shift_split[1]
  end

  def shift_time(direction)
    if direction == "forward"
      shift_forward
    elsif direction == "backward"
      shift_backward
    end
    newms = (@seconds * 1000) + @milliseconds + @shift
    array = [@hours, @minutes, newms / 1000, newms % 1000]
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
    Timecode.new(array)
  end

  def shift_forward
    @shift
  end

  def shift_backward
    @shift = @shift * -1
  end

  def negative?
    if @time_array.select { |i| i < 0}.empty?
      return false
    else
      return true
    end
  end
end
