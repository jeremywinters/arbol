class LFOSquare < Base
  Irontofu.add_mapped_class(
    'lfo_square', 
    LFOSquare,
%{long half_int_scale_vec[3] = {long(INTEGER_SCALE / 2), long(INTEGER_SCALE / 2), long(INTEGER_SCALE / 2)};
void lfo_square(long mils, long cycle_ms[3], long out[3]) {
  long phase[3];
  phasor(mils, cycle_ms, phase);
  greater_than(phase, half_int_scale_vec, out);
}}
  )
  attr_accessor :cycle_ms
  
  def param_keys
    [:cycle_ms]
  end

  def arduino_code
    [
      "long #{@name}[3];",
      "lfo_square(mils, #{@cycle_ms.name}, #{@name});"
    ]
  end
  
  def function_code

  end
end

def lfo_square(cycle_ms)
  h = ArbolHash.new
  h[:type] = 'lfo_square'
  h[:cycle_ms] = resolve(cycle_ms)
  h
end