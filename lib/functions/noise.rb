class Noise < Base
  Irontofu.add_mapped_class(
    'noise', 
    Noise,
%{void noise(long out[3]) {
  out[0] = random(INTEGER_SCALE);
  out[1] = random(INTEGER_SCALE);
  out[2] = random(INTEGER_SCALE);
}}
  )
  def arduino_code
    [
      "long #{@name}[3];",
      "noise(mils, #{@name});"
    ]
  end
end

def noise
  {
    type: 'noise'
  }
end