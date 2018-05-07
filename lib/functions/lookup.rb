class Lookup < Base
  Irontofu.add_mapped_class(
    'lookup', 
    Lookup,
%{//void lookup(long index[3], long table[][3], long table_size, long out[3]) {
//  out[0] = table[long_mult(index[0], table_size)];
//  out[1] = table[long_mult(index[1], table_size)];
//  out[2] = table[long_mult(index[2], table_size)];
//}}
  )
  
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:index, :table]
  end
  
  def arduino_code
    [
      "long #{@name}[3];",
      "lookup(#{@index.name},  #{@name});"
    ]
  end
end

def lookup(table, index)
  {
    type: 'lookup',
    table: table,
    index: resolve(index)
  }
end