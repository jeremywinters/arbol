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
    [
      "phasor(mils, #{@cycles.name}, #{@name});"
    ]
  end

  def top_level_scope_code
    [
      "long #{@name}[3];"
    ]
  end
end

def phasor(cycles)
  h = ArbolHash.new
  h[:type] = 'phasor'
  h[:cycles] = resolve(cycles)
  h
end