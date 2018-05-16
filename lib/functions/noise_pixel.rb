class NoisePixel < Base
  Irontofu.add_mapped_class(
    'noise_pixel', 
    NoisePixel,
%{void noise_pixel(long out[3]) {
  out[0] = random(INTEGER_SCALE);
  out[1] = out[0];
  out[2] = out[1];
}}
  )
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

def noise_pixel
  h = ArbolHash.new
  h[:type] = 'noise_pixel'
  h
end