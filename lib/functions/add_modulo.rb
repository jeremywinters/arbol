class AddModulo < Base
  Arbol.add_mapped_class(
    'add_modulo', 
    AddModulo,
%{void add_modulo(long op1[3], long op2[3], long out[3]) {
  out[0] = (op1[0] + op2[0]) % INTEGER_SCALE;
  out[1] = (op1[1] + op2[1]) % INTEGER_SCALE;
  out[2] = (op1[2] + op2[2]) % INTEGER_SCALE;
}}
  )
  
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "add_modulo(#{@op1.name}, #{@op2.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "add_modulo(#{@op1.name}, #{@op2.name}, #{@name});"
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

def add_modulo   
%{--
### add\_modulo(op1, op2)

* **op1** - operator1
* **op2** - operator2

Adds op1 and op2, then returns the result modulo 1.0.

}
end

  end
end

def add_modulo(op1, op2)
  h = ArbolHash.new
  h[:type] = 'add_modulo'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end