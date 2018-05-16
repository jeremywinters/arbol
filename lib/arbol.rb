require 'pp'
require_relative 'builder.rb'

# now that class_map is created.. import all functions
Dir.glob("#{File.dirname(__FILE__)}/functions/*.rb").each do |mod|
  require_relative mod
end

def scale_correctly(val)
  case
    when val.class == Fixnum then return val
    when val.class == Float then return (val * 8191).to_i
  end
end

def resolve(val)
  case
    when val.class == Fixnum then return my_const(scale_correctly(val))
    when val.class == Float then return my_const(scale_correctly(val))
    when val.class == Array then return my_const(
      val.map { |i| scale_correctly(i) }
    )
    when val.class == ArbolHash then return val
  end
end

def coerce_array(input)
  # puts "coerce #{input}"
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

def strip_comments(script)
  t = []
  script.split("\n").each do |line|
    if line.match(/\#/)
      t << line.split('#',2)[0]
    else
      t << line
    end
  end
  t.join
end

def script_split(script)
  script.split(';').select { |l| l.strip != '' }
end

def stmts_to_structure(stmts)
  refs = []
  refinjects = ['using RefineBasics; ']
  stmts.each do |stmt|
    if stmt.match(/(\w|\s)+={1}(\w|\s)+/)
      ref_name = stmt.match(/\w+/)[0]
      statements = "#{refinjects.join('')}#{stmt.split('=')[1]}"
      this_ref = create_ref(
        ref_name,
        eval(statements, binding)
      )
      refinject = "#{ref_name} = ref('#{ref_name}');"
      refs << this_ref
      refinjects << refinject
    elsif stmt.match('strip')
      statements = "#{refinjects.join('')} #{stmt}"
      retval = eval(statements, binding)
      retval[:refs] = refs
      return retval
    end
  end
end

def interpret(file_path)
  tree = nil
  if file_path.match(/\.rb$/)
    tree = stmts_to_structure(
      script_split(
        strip_comments(
          File.read(file_path)
        )
      )
    )
  elsif file_path.match(/\.json$/)
    puts "json"
    tree = JSON.parse(
      File.read(
        file_path
      ),
      symbolize_names: true
    )
  end
  tree
end

def tree_to_file(tree, path)
  pp tree
  tls, body = custom_arduino_script_body(tree)
  tls = tls.join("\n")
  body = body.join("\n")
  pixels = tree[:lamps]
  pin = tree[:pin]
  code = Irontofu.libs.join("\n\n")
  puts "writing to script file #{path}"
  f = File.open(path, 'w')
  f.puts ERB.new(IO.read("#{File.dirname(__FILE__)}/templates/arduino_library.ino.erb")).result(binding)
  f.close
end