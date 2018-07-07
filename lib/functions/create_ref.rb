$refs = {}
$refs_frame_optimized = {}

class CreateRef < Base
  Arbol.add_mapped_class('create_ref', CreateRef, nil)
  attr_accessor :identifier
  attr_accessor :value
  
  def initialize(params)
    super(params)
    @identifier = params[:identifier]
    resolve_frame_optimized
    unless $refs.has_key?(@identifier)
      $refs[@identifier] = @name
      $refs_frame_optimized[@identifier] = @frame_optimized
    else
      raise "duplicate ref definition #{params[:name]}"
    end
  end

  def param_keys
    [:value]
  end
  
  def arduino_code
    []
  end

  def top_level_scope_code
    [
      "long *#{@name} = #{@value.name};"
    ]
  end
end

def create_ref(identifier, value)
  h = ArbolHash.new
  if value.class == ArbolTable
    h[:type] = 'create_lookup'
    h[:identifier] = identifier
    h[:value] = resolve_lookup(value.table)
  else
    h[:type] = 'create_ref'
    h[:identifier] = identifier
    h[:value] = resolve(value)
  end
  h
end