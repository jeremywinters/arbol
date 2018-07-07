class Divide < Base
  Arbol.add_mapped_class(
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
    unless @frame_optimized 
      [
        "divide(#{@numerator.name}, #{@denominator.name}, #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "divide(#{@numerator.name}, #{@denominator.name}, #{@name});"
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

  def divide   
%{--
### divide(numerator, denominator)

* **numerator**
* **denominator**

Division. Also accepts the form `numerator / denominator`.

}
  end

  end
end

def divide(numerator, denominator)
  h = ArbolHash.new
  h[:type] = 'add'
  h[:numerator] = resolve(numerator)
  h[:denominator] = resolve(denominator)
  h
end