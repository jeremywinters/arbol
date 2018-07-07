class Minimum < Base
  Arbol.add_mapped_class(
    'min', 
    Minimum,
%{void minimum(long op1[3], long op2[3], long out[3]) {
  out[0] = min(op1[0], op2[0]);
  out[1] = min(op1[1], op2[1]);
  out[2] = min(op1[2], op2[2]);
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
        "minimum(#{@op1.name}, #{@op2.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "minimum(#{@op1.name}, #{@op2.name}, #{@name});"
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

  def min 
%{--
### min(left, right)

* **operator1**
* **operator2**

Minimum (least) of the two operators.

}
  end

  end
end

def min(op1, op2)
  h = ArbolHash.new
  h[:type] = 'min'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end