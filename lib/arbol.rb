require 'pp'
require_relative 'builder.rb'
require_relative 'dsl.rb'
require_relative 'documentation.rb'

# now that class_map is created.. import all functions
Dir.glob("#{File.dirname(__FILE__)}/functions/*.rb").each do |mod|
  require_relative mod
end

# interprets a file into an arbol tree structure
def interpret_file(file_path, scope)
  if file_path.match(/\.rb$/)
    return interpret_dsl(File.read(file_path), scope)
  elsif file_path.match(/\.json$/)
    return interpret_json(File.read(file_path))
  end
end

# creates an ino file from a tree structure.
def ino_from_tree(tree)
  pp tree
  tls, cycle, body = custom_arduino_script_body(tree)
  # these are resolved inside the ERB
  tls = tls.join("\n")
  cycle = cycle.join("\n")
  body = body.join("\n")
  integer_scale = 8192
  pixels = tree[:lamps]
  pin = tree[:pin]
  code = Arbol.libs.join("\n\n")
  ERB.new(
    IO.read(
      "#{File.dirname(__FILE__)}/templates/arduino_library.ino.erb"
    )
  ).result(binding)
end

# write the script to file
def script_to_file(script, path)
  puts "writing to script file #{path}"
  File.open(path, 'w') do |f|
    f.puts(script)
  end
end