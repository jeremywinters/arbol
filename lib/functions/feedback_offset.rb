class FeedbackOffset < Base
  Arbol.add_mapped_class(
    'feedback_offset',
    FeedbackOffset,
%{void feedback_offset(int pixel, int pixel_count, long input[3], long feedback[3], long offset[3], long storage[][3], long out[3]) {
  out[0] = max(input[0], storage[(pixel + long_mult(offset[0], pixel_count)) % pixel_count][0]);
  out[1] = max(input[1], storage[(pixel + long_mult(offset[1], pixel_count)) % pixel_count][1]);
  out[2] = max(input[2], storage[(pixel + long_mult(offset[2], pixel_count)) % pixel_count][2]);
  storage[pixel][0] = constrain(long_mult(out[0], feedback[0]), 0, INTEGER_SCALE);
  storage[pixel][1] = constrain(long_mult(out[1], feedback[1]), 0, INTEGER_SCALE);
  storage[pixel][2] = constrain(long_mult(out[2], feedback[2]), 0, INTEGER_SCALE);
}}
  )

  attr_accessor :input
  attr_accessor :feedback
  attr_accessor :offset

  def initialize(params)
    super(params)
    @frame_optimized = false
  end

  def param_keys
    [:input, :feedback, :offset]
  end

  def arduino_code
    [
      "feedback_offset(i, PIXEL_COUNT, #{@input.name}, #{@feedback.name}, #{@offset.name}, #{@name}_storage, #{@name});"
    ]
  end

  def top_level_scope_code
    [
      "long #{@name}[3];",
      "long #{@name}_storage[PIXEL_COUNT][3];"
    ]
  end
end

module Arbol
  class Documentation

  def feedback_offset   
%{--
### feedback\_offset(input, feedback, offset)

* **input**
* **feedback**
* **offset**

Returns the greatest of the input or the feedback value at the offset (0-~1.0) 
from the current pixel.

}
  end

  end
end

def feedback_offset(input, feedback, offset)
  h = ArbolHash.new
  h[:type] = 'feedback_offset'
  h[:input] = resolve(input)
  h[:feedback] = resolve(feedback)
  h[:offset] = resolve(offset)
  h
end