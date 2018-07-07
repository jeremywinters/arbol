class Feedback < Base
  Arbol.add_mapped_class(
    'feedback', 
    Feedback,
%{void feedback(int pixel, long input[3], long feedback[3], long storage[][3], long out[3]) {
  out[0] = max(input[0], storage[pixel][0]);
  out[1] = max(input[1], storage[pixel][1]);
  out[2] = max(input[2], storage[pixel][2]);
  storage[pixel][0] = constrain(long_mult(out[0], feedback[0]), 0, INTEGER_SCALE);
  storage[pixel][1] = constrain(long_mult(out[1], feedback[1]), 0, INTEGER_SCALE);
  storage[pixel][2] = constrain(long_mult(out[2], feedback[2]), 0, INTEGER_SCALE);
}}
  )
  
  attr_accessor :input
  attr_accessor :feedback

  def initialize(params)
    super(params)
    @frame_optimized = false
  end
 
  def param_keys
    [:input, :feedback]
  end
  
  def arduino_code
    [
      "feedback(i, #{@input.name}, #{@feedback.name}, #{@name}_storage, #{@name});"
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

  def feedback  
%{--
### feedback(input, feedback)

* **input**
* **feedback**

Returns the greatest of the input or the feedback value.

}
  end

  end
end

def feedback(input, feedback)
  h = ArbolHash.new
  h[:type] = 'feedback'
  h[:input] = resolve(input)
  h[:feedback] = resolve(feedback)
  h
end