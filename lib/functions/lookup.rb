class Lookup < Base
  Arbol.add_mapped_class(
    'lookup', 
    Lookup,
%{void lookup(long index[3], long table[][3], long table_size, long out[3]) {
  out[0] = table[long_mult(index[0], table_size)][0];
  out[1] = table[long_mult(index[1], table_size)][1];
  out[2] = table[long_mult(index[2], table_size)][2];
}}
  )
  
  attr_accessor :op1
  attr_accessor :op2
  
  def param_keys
    [:index, :table]
  end

  def arduino_code
    unless @frame_optimized 
      [
        "lookup(#{@index.name}, #{@table}, #{tables[@table].length}, long #{@name});"
      ]
    else
      []
    end
  end
  
  def cycle_level_arduino_code
    if @frame_optimized
      [
        "lookup(#{@index.name}, #{@table}, #{tables[@table].length}, long #{@name});"
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

  def lookup 
%{--
### lookup(table\\_reference, index)

* **table\\_reference** - reference to a predefined table.
* **index** - index used to look up the value in the table.

Allows you to lookup values in a user defined table. Note that the table must be declared before it is referenced.

```
my_table = [0, 0.5, 0.6, 0.0, 0.9];

my_lookup = lookup(
  my_table,
  phasor(1000)
);
```
}
  end

  end
end

def resolve_table_reference(table_ref)
  if $tables.has_key?(table_ref)
    table_ref
  else
    raise "table #{table_ref} invalid"
  end
end

def lookup(table, index)
  {
    type: 'lookup',
    table: resolve_table_reference(table),
    index: resolve(index)
  }
end