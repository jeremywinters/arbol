class Modulo < Base
  Irontofu.add_mapped_class(
    'modulo', 
    Modulo,
%{void modulo(long op1[3], long op2[3], long out[3]) {
  out[0] = op1[0] % op2[0];
  out[1] = op1[1] % op2[1];
  out[2] = op1[2] % op2[2];
}}
  )
  
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:op1, :op2]
  end
  
  def arduino_code
    [
      "long #{@name}[3];",
      "modulo(#{@op1.name}, #{@op2.name}, #{@name});"
    ]
  end
end

def mod(op1, op2)
  h = ArbolHash.new
  h[:type] = 'modulo'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end