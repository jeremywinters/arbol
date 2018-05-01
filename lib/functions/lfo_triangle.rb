class LFOTriangle < Base
  Irontofu.add_mapped_class(
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
    [
      "long #{@name}[3];",
      "lfo_triangle(mils, #{@cycle_ms.name}, #{@name});"
    ]
  end
end

def lfo_triangle(cycle_ms)
  {
    type: 'lfo_triangle',
    cycle_ms: resolve(cycle_ms)
  }
end