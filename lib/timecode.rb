# This is way overkill for dealing with just a simple string and there's probably a simpler way to deal with some of these issues.
class Timecode
  attr_accessor :hours, :minutes, :seconds, :milliseconds, :shift
  # Only requires a timecode, can be either a string or array
  # @param [String] string in format "hh:mm:ss,ms"
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

  # Converts the timecode string into an array
  #
  # @return [Array] [hours, minutes, seconds, milliseconds]
  def to_array
    colon_split = @timecode.split(":") 
    comma_split = colon_split[2].split(",")
    time_array = [colon_split[0], colon_split[1], comma_split[0], comma_split[1]]
    time_array.map! {|a| a.to_i}
  end

  # Outputs the timecode as a string
  #
  # @return [String] "hours:minutes:seconds,milliseconds"
  def to_s
    string = "%02d:%02d:%02d,%03d" % @time_array
  end

  # Setter takes a string 
  # Getter returns an integer
  #
  # @param [String] format "ss,mmm" i.e. "seconds,milliseconds"
  # @return [Integer] seconds * 1000 + milliseconds
  def shift=(shift)
    @shift = shift_calc(shift)
  end

  # Converts the "ss,mmm" shift format into an integer so we can do math on it
  #
  # @param [String] format "ss,mmm" i.e. "seconds,milliseconds"
  # @return [Integer] returns that integer if you need it
  def shift_calc(shift_value)
    shift_split = shift_value.split(",")
    shift_split.map! {|a| a.to_i}
    shift = (shift_split[0] * 1000) + shift_split[1]
  end

  # Shifts the time in a specified direction
  #
  # @param [String] either "forward" or "backward"
  # @return [Timecode] returns a new Timecode object
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

  def negative?
    if @time_array.select { |i| i < 0}.empty?
      return false
    else
      return true
    end
  end

  private

  # Shift time forward
  #
  # @return [Integer] just returns the @shift value.  This is completely unnecessarily.
  def shift_forward
    @shift
  end

  # Shift time backward
  #
  # @return [Integer] turns @shift negative.
  def shift_backward
    @shift = @shift * -1
  end

end
