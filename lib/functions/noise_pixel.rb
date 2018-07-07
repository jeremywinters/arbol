class NoisePixel < Base
  Arbol.add_mapped_class(
    'noise_pixel', 
    NoisePixel,
%{void noise_pixel(long out[3]) {
  out[0] = random(INTEGER_SCALE);
  out[1] = out[0];
  out[2] = out[1];
}}
  )
  
  def initialize(params)
    super(params)
    @frame_optimized = false
  end
  
  def arduino_code
    [
      "noise_pixel(#{@name});"
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

  def noise_pixel 
%{--
### noise\\_pixel

Outputs a random value for each pixel.

}
  end

  end
end

def noise_pixel
  h = ArbolHash.new
  h[:type] = 'noise_pixel'
  h
end