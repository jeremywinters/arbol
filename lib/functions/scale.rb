class Scale < Base
  Arbol.add_mapped_class(
    'scale', 
    Scale,
%{void scale(long input[3], long lo_in[3], long hi_in[3], long lo_out[3], long hi_out[3], long out[3]) {
  out[0] = map(input[0], lo_in[0], hi_in[0], lo_out[0], hi_out[0]);
  out[1] = map(input[1], lo_in[1], hi_in[1], lo_out[1], hi_out[1]);
  out[2] = map(input[2], lo_in[2], hi_in[2], lo_out[2], hi_out[2]);
}}
  )
  
  attr_accessor :input
  attr_accessor :lo_in
  attr_accessor :hi_in
  attr_accessor :lo_out
  attr_accessor :hi_out
  
  def param_keys
    [:input, :lo_in, :hi_in, :lo_out, :hi_out]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "scale(#{@input.name}, #{@lo_in.name}, #{@hi_in.name}, #{@lo_out.name}, #{@hi_out.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "scale(#{@input.name}, #{@lo_in.name}, #{@hi_in.name}, #{@lo_out.name}, #{@hi_out.name}, #{@name});"
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

  def scale
%{--
### scale needs doc

}
  end

  end
end

def scale(input, lo_in, hi_in, lo_out, hi_out)
  h = ArbolHash.new
  h[:type] = 'scale'
  h[:input] = resolve(input)
  h[:lo_in] = resolve(lo_in)
  h[:hi_in] = resolve(hi_in)
  h[:lo_out] = resolve(lo_out)
  h[:hi_out] = resolve(hi_out)
  h
end