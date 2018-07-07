class Ref < Base
  Arbol.add_mapped_class('ref', Ref, nil)
  attr_accessor :identifier
  attr_accessor :ref_name
  
  def initialize(params)
    super(params)
    @identifier = params[:identifier]
    if $refs.has_key?(@identifier)
      @ref_name = $refs[@identifier]
      @frame_optimized = $refs_frame_optimized[@identifier]
    else
      raise "non-existant ref #{@identifier}"
    end
  end
  
  def arduino_code
    [
    ]
  end

  def top_level_scope_code
    [
      "long *#{@name} = #{@ref_name};"
    ]
  end
end

def ref(identifier)
  h = ArbolHash.new
  h[:type] = 'ref'
  h[:identifier] = identifier
  h
end