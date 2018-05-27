def scale_correctly(val)
  case
    when val.class == Integer then return val
    when val.class == Float then return (val * 8192).to_i
  end
end

def resolve(val)
  case
    when val.class == Integer then return my_const(scale_correctly(val))
    when val.class == Float then return my_const(scale_correctly(val))
    when val.class == Array then return my_const(
      val.map { |i| scale_correctly(i) }
    )
    when val.class == ArbolHash then return val
  end
end

def coerce_array(input)
  if input.class == Array
    input
  else
    [input, input, input]
  end
end

def strip(lamps, pin, calc)
  {
    type: 'physical_strip',
    lamps: lamps,
    pin: pin,
    calc: resolve(calc)
  }
end

def remove_comments(script)
  t = []
  script.split("\n").each do |line|
    if line.match(/\#/)
      t << line.split('#',2)[0]
    else
      t << line
    end
  end
  t.join("\n")
end

def script_split(script)
  script.split(';').select { |l| l.strip != '' }
end

def stmts_to_structure(stmts, scope)
  refs = []
  refinjects = ['using RefineBasics; ']
  stmts.each do |stmt|
    if stmt.match(/(\w|\s)+={1}(\w|\s)+/)
      ref_name = stmt.match(/\w+/)[0]
      statements = "#{refinjects.join('')}#{stmt.split('=')[1]}"
      this_ref = create_ref(
        ref_name,
        eval(statements, scope)
      )
      refinject = "#{ref_name} = ref('#{ref_name}');"
      refs << this_ref
      refinjects << refinject
    elsif stmt.match('strip')
      statements = "#{refinjects.join('')} #{stmt}"
      retval = eval(statements, scope)
      retval[:refs] = refs
      return retval
    end
  end
end

def interpret_dsl(script_text, scope)
  stmts_to_structure(
    script_split(
      remove_comments(
        script_text
      )
    ),
    scope
  )
end

def interpret_json(json_text)
  JSON.parse(
    json_text,
    symbolize_names: true
  )
end