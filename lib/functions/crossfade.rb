class Crossfade < Base
  Arbol.add_mapped_class(
    'crossfade', 
    Crossfade,
%{void crossfade(long fader[3], long channel1[3], long channel2[3], long out[3]) {
  out[0] = long_mult(INTEGER_SCALE - 1 - fader[0], channel1[0]) + long_mult(fader[0], channel2[0]);
  out[1] = long_mult(INTEGER_SCALE - 1 - fader[1], channel1[1]) + long_mult(fader[1], channel2[1]);
  out[2] = long_mult(INTEGER_SCALE - 1 - fader[2], channel1[2]) + long_mult(fader[2], channel2[2]);
}}
  )
  
  attr_accessor :fader
  attr_accessor :channel1
  attr_accessor :channel2
  
  def param_keys
    [:fader, :channel1, :channel2]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "crossfade(#{@fader.name}, #{@channel1.name}, #{@channel2.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "crossfade(#{@fader.name}, #{@channel1.name}, #{@channel2.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def top_level_scope_code
    [
      "long #{@name}[3];",
    ]
  end
end

module Arbol
  class Documentation

  def crossfade   
%{--
### crossfade(fader, channel1, channel2)

* **fader** - fade amount between channels
* **channel1** - channel1
* **channel2** - channel2

Returns a mix of channels 1 and 2 based on the fader amount between 0-~1.0.

}
  end

  end
end

def crossfade(fader, channel1, channel2)
  h = ArbolHash.new
  h[:type] = 'crossfade'
  h[:fader] = resolve(fader)
  h[:channel1] = resolve(channel1)
  h[:channel2] = resolve(channel2)
  h
end