class LampPhase < Base
  Arbol.add_mapped_class('lamp_phase', LampPhase, nil)
  def arduino_code
    [
      "long #{@name}[3] = {this_phase, this_phase, this_phase};"
    ]
  end

  def top_level_scope_code
    []
  end
end

def lamp_phase
  h = ArbolHash.new
  h[:type] = 'lamp_phase'
  h
end