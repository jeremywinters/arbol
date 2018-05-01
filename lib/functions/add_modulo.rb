class AddModulo < Base
  Irontofu.add_mapped_class(
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
    [
      "long #{@name}[3];",
      "add_modulo(#{@op1.name}, #{@op2.name}, #{@name});"
    ]
  end
end

def add_modulo()
  {
    type: 'add_modulo',
    op1: resolve(op1),
    op2: resolve(op2)
  }
end