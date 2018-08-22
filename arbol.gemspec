Gem::Specification.new do |s|
  s.name        = 'arbol'
  s.version     = '0.0.3'
  s.date        = '2018-07-07'
  s.summary     = "functional streams for neopixel strips"
  s.description = "define DSP-like function chains for your lights"
  s.authors     = ["jeremy winters"]
  s.email       = 'jeremyranierwinters@gmail.com'
  s.files       = ["lib/arbol.rb"]
  s.executables << 'arbol'

  Dir.glob('lib/**/*rb').each {|f| s.files << f; puts f}

  s.homepage    = 'https://www.github.com'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 2.4'
end
