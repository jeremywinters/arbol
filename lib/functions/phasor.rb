class Phasor < Base
  Arbol.add_mapped_class(
    'phasor', 
    Phasor,
%{void phasor(long mils, long cycle[3], long out[3]) {
  out[0] = long_div((mils % cycle[0]), cycle[0]);
  out[1] = long_div((mils % cycle[1]), cycle[1]);
  out[2] = long_div((mils % cycle[2]), cycle[2]);
}}
  )
  attr_accessor :cycles
  
  def param_keys
    [:cycles]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "phasor(mils, #{@cycles.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "phasor(mils, #{@cycles.name}, #{@name});"
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

  def phasor 
%{--
### phasor(cycle_ms)

* **cycle_ms**

Outputs a ramp wave from 0-~1.0 over a period of cycle_ms milliseconds.

`phasor` is very important because it highlights a key way to bring motion into
the system. There are many ways of using phasor.

```
# go from 0-~1.0 over a period of 10 seconds:
phasor(10000)

# each of the three channels goes from 0-~1.0 at different millisecond intervals:
phasor([1000, 1100, 1200])

# phasor is input into a triangle function, which then creates a triangle
# wave that goes from 0-~1.0-0 over a period of 5 seconds specified
# to the phasor
tri = triangle(phasor(5000))

# multiple two triangles together to to get a pointy triangle
tri_squared = tri * tri

# using `lamp_phase` function in conjunction with `add_constrain` you can
# create motion in the lamps.

strip(
  512, # 512 pixels
  0,   # attached to pin 0
  add_constrain(
    lamp_phase,
    phasor([1000, 1200, 1300])  
  )
```

}
  end

  end
end

def phasor(cycles)
  h = ArbolHash.new
  h[:type] = 'phasor'
  h[:cycles] = resolve(cycles)
  h
end