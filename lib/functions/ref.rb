class Ref < Base
  Irontofu.add_mapped_class('ref', Ref, nil)
  attr_accessor :identifier
  attr_accessor :ref_name
  
  def initialize(params)
    super(params)
    puts params
    @identifier = params[:identifier]
    if $refs.has_key?(@identifier)
      @ref_name = $refs[@identifier]
    else
      raise "non-existant ref #{@identifier}"
    end
  end
  
  def arduino_code
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