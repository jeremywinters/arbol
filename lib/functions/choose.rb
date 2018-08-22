class Choose < Base
  Arbol.add_mapped_class(
    'choose',
    Choose,
%{long choose_half_phase = INTEGER_SCALE / 2 - 1;
void choose(long choice[3], long op1[3], long op2[3], long out[3], long threshold) {
  if(choice[0] <= threshold) { out[0] = op1[0];} else { out[0] = op2[0]; }
  if(choice[1] <= threshold) { out[1] = op1[1];} else { out[1] = op2[1]; }
  if(choice[2] <= threshold) { out[2] = op1[2];} else { out[2] = op2[2]; }
}}
  )

  attr_accessor :choice
  attr_accessor :op1
  attr_accessor :op2

  def param_keys
    [:choice, :op1, :op2]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "choose(#{@choice.name}, #{@op1.name}, #{@op2.name}, #{@name}, choose_half_phase);"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "choose(#{@choice.name}, #{@op1.name}, #{@op2.name}, #{@name}, choose_half_phase);"
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

  def choose   
%{--
### choose(choice, op1, op2)

* **choice** - selects the operator to be returned
* **op1** - operator1
* **op2** - operator2

Returns operator1 if choice < 0.5.. or operator2 if choice >= 0.5.

}
  end

  end
end

def choose(choice, op1, op2)
  h = ArbolHash.new
  h[:type] = 'choose'
  h[:choice] = resolve(choice)
  h[:op1] = resolve(op1)
  h[:op2] = resolve(op2)
  h
end