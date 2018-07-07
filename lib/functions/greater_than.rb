class GreaterThan < Base
  Arbol.add_mapped_class(
    'greater_than', 
    GreaterThan,
%{void greater_than(long left[3], long right[3], long out[3]) {
  if(left[0] > right[0]) { out[0] = INTEGER_SCALE; } else { out[0] = 0; }
  if(left[1] > right[1]) { out[1] = INTEGER_SCALE; } else { out[1] = 0; }
  if(left[2] > right[2]) { out[2] = INTEGER_SCALE; } else { out[2] = 0; }
}}
  )
  attr_accessor :left
  attr_accessor :right
  
  def param_keys
    [:left, :right]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "greater_than(#{@left.name}, #{@right.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "greater_than(#{@left.name}, #{@right.name}, #{@name});"
      ]
    else
      []
    end
  end

  def top_level_scope_code
    [
      "long #{@name}[3];"
    ]
  end
end

module Arbol
  class Documentation

  def greater_than 
%{--
### greater\_than(left, right)

* **left** - left operand
* **right** - right operand

left > right as a logical operation returning 0 or 1.0.
Can be used in the form `left > right`.

}
  end

  end
end

def greater_than(left, right)
  h = ArbolHash.new
  h[:type] = 'greater_than'
  h[:left] = resolve(left)
  h[:right] = resolve(right)
  h
end