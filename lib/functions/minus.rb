class Minus < Base
  Arbol.add_mapped_class(
    'minus', 
    Minus,
%{void minus(long op1[3], long op2[3], long out[3]) {
  out[0] = op1[0] - op2[0];
  out[1] = op1[1] - op2[1];
  out[2] = op1[2] - op2[2];
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
        "minus(#{@op1.name}, #{@op2.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "minus(#{@op1.name}, #{@op2.name}, #{@name});"
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

  def minus 
%{--
### minus(operator1, operator2)

* **operator1**
* **operator2**

Difference of the two operators. Can also be used with the form `operator1 - operator2`.

}
  end

  end
end

def minus(op1, op2)
  h = ArbolHash.new
  h[:type] = 'minus'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end