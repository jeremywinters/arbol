class LFOTriangle < Base
  Arbol.add_mapped_class(
    'lfo_triangle', 
    LFOTriangle,
%{long twice_int_scale_vec[3] = {long(INTEGER_SCALE * 2), long(INTEGER_SCALE * 2), long(INTEGER_SCALE * 2)};
void lfo_triangle(long mils, long cycle_ms[3], long out[3]) {
  long phase[3];
  phasor(mils, cycle_ms, phase);
  long times_result[3];
  times(phase, twice_int_scale_vec, times_result);
  if(times_result[0] > INTEGER_SCALE) { out[0] = (twice_int_scale_vec[0] - times_result[0]); } else { out[0] = times_result[0]; }
  if(times_result[1] > INTEGER_SCALE) { out[1] = (twice_int_scale_vec[1] - times_result[1]); } else { out[1] = times_result[1]; }
  if(times_result[2] > INTEGER_SCALE) { out[2] = (twice_int_scale_vec[2] - times_result[2]); } else { out[2] = times_result[2]; }
}}
  )
  attr_accessor :cycle_ms
  
  def param_keys
    [:cycle_ms]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "lfo_triangle(mils, #{@cycle_ms.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "lfo_triangle(mils, #{@cycle_ms.name}, #{@name});"
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

  def lfo_triangle 
%{--
### lfo\\_triangle(cycle\\_ms)

* **cycle\\_ms** - cycle length expressed as milliseconds

Outputs a triangle wave. Note that the cycle length value is interpreted literally
as milliseconds, so you should use integer constants as input.

}
  end

  end
end

def lfo_triangle(cycle_ms)
  h = ArbolHash.new
  h[:type] = 'lfo_triangle'
  h[:cycle_ms] = resolve(cycle_ms)
  h
end