class Add < Base
  Arbol.add_mapped_class(
    'add', 
    Add,
%{void add(long op1[3], long op2[3], long out[3]) {
  out[0] = op1[0] + op2[0];
  out[1] = op1[1] + op2[1];
  out[2] = op1[2] + op2[2];
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
        "add(#{@op1.name}, #{@op2.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "add(#{@op1.name}, #{@op2.name}, #{@name});"
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

  def add   
%{--
### add(op1, op2)

* **op1** - operator1
* **op2** - operator2

Adds op1 and op2. can also be used in the form `op1 + op2`.

}
  end

  end
end

def add(op1, op2)
  h = ArbolHash.new
  h[:type] = 'add'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end