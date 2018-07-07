class LampPhase < Base
  Arbol.add_mapped_class('lamp_phase', LampPhase, nil)

  def initialize(params)
    super(params)
    @frame_optimized = false
  end
    
  def arduino_code
    [
      "long #{@name}[3] = {this_phase, this_phase, this_phase};"
    ]
  end

  def top_level_scope_code
    []
  end
end

module Arbol
  class Documentation

  def lamp_phase 
%{--
### lamp\_phase

Returns current lamp number expressed as a phase 0-~1.0.

}
  end

  end
end

def lamp_phase
  h = ArbolHash.new
  h[:type] = 'lamp_phase'
  h
end