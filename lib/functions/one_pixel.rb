class OnePixel < Base
  Arbol.add_mapped_class(
    'one_pixel', 
    OnePixel,
"long one_pixel_phase[3] = { 
  long(1.0 / float(PIXEL_COUNT) * float(INTEGER_SCALE)),
  long(1.0 / float(PIXEL_COUNT) * float(INTEGER_SCALE)),
  long(1.0 / float(PIXEL_COUNT) * float(INTEGER_SCALE))
};

void one_pixel(long mils, long phase[3], long out[3]) {
  less_than(phase, one_pixel_phase, out);
}"
  )
  attr_accessor :phase
  
  def param_keys
    [:phase]
  end

  def arduino_code
    [
      "one_pixel(mils, #{@phase.name}, #{@name});"
    ]
  end
  
  def top_level_scope_code
    [
      "long #{@name}[3];"
    ]
  end
end

def one_pixel(phase)
  h = ArbolHash.new
  h[:type] = 'one_pixel'
  h[:phase] = resolve(phase)
  h
end