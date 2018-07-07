class Noise < Base
  Arbol.add_mapped_class(
    'noise', 
    Noise,
%{void noise(long out[3]) {
  out[0] = random(INTEGER_SCALE);
  out[1] = random(INTEGER_SCALE);
  out[2] = random(INTEGER_SCALE);
}}
  )

  def initialize(params)
    super(params)
    @frame_optimized = false
  end
   
  def arduino_code
    [
      "noise(#{@name});"
    ]
  end

  def top_level_scope_code
    [
      "long #{@name}[3];"
    ]
  end
end

module Arbol
  class Documentation

  def noise
%{--
### noise

Outputs a random value for RGB of each pixel.

}
  end

  end
end

def noise
  h = ArbolHash.new
  h[:type] = 'noise'
  h
end