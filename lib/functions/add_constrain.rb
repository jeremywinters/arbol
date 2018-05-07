class AddConstrain < Base
  Irontofu.add_mapped_class(
    'add_constrain', 
    AddConstrain,
%{void add_constrain(long op1[3], long op2[3], long out[3]) {
  out[0] = constrain(op1[0] + op2[0], 0, INTEGER_SCALE);
  out[1] = constrain(op1[1] + op2[1], 0, INTEGER_SCALE);
  out[2] = constrain(op1[2] + op2[2], 0, INTEGER_SCALE);
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
      "add_constrain(#{@op1.name}, #{@op2.name}, #{@name});"
    ]
  end
  
  def documentation
%{
### add_constrain(op1, op2)

* **op1** - operator1
* **op2** - operator2

Adds op1 and op2, then constrains the result between 0.0-~1.0.
}
  end
end

def add_constrain(op1, op2)
  h = ArbolHash.new
  h[:type] = 'add_constrain'
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end