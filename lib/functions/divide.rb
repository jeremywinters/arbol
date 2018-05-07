class Divide < Base
  Irontofu.add_mapped_class(
    'divide', 
    Divide,
%{void divide(long numerator[3], long denominator[3], long out[3]) {
  out[0] = long_div(numerator[0], denominator[0]);
  out[1] = long_div(numerator[1], denominator[1]);
  out[2] = long_div(numerator[2], denominator[2]);
}}
  )
  
  attr_accessor :numerator
  attr_accessor :denominator
  
  def param_keys
    [:numerator, :denominator]
  end
  
  def arduino_code
    [
      "long #{@name}[3];",
      "divide(#{@numerator.name}, #{@denominator.name}, #{@name});"
    ]
  end
end

def divide(numerator, denominator)
  h = ArbolHash.new
  h[:type] = 'add'
  h[:numerator] = resolve(numerator)
  h[:denominator] = resolve(denominator)
  h
end