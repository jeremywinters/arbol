class ArbolTable
  attr_accessor :table
  
  def initialize(tbl)
    @table = tbl
  end
end
    

# really this is just a pass through for arrays
# used in lookup table creation
def table(contents)
  if contents.class == Array
    ArbolTable.new(contents)
  end
end