class Times < Base
  Arbol.add_mapped_class(
    'times', 
    Times,
%{void times(long op1[3], long op2[3], long out[3]) {
  out[0] = long_mult(op1[0], op2[0]);
  out[1] = long_mult(op1[1], op2[1]);
  out[2] = long_mult(op1[2], op2[2]);
}}
  )
  
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
  
  def arduino_code
    [
      "times(#{@op1.name}, #{@op2.name}, #{@name});"
    ]
  end

  def top_level_scope_code
    [
      "long #{@name}[3];",
    ]
  end
end

def times(op1, op2)
  h = ArbolHash.new
  h[:type] = 'times'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end