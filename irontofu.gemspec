
Gem::Specification.new do |s|
  s.name        = 'irontofu'
  s.version     = '0.0.1'
  s.date        = '2018-04-30'
  s.summary     = "functional streams for neopixel strips"
  s.description = "define DSP-like function chains for your lights"
  s.authors     = ["jeremy winters"]
  s.email       = 'jeremyranierwinters@gmail.com'
  s.files       = ["lib/irontofu.rb"]
  s.executables << 'irontofu'

  Dir.glob('lib/**/*rb').each {|f| s.files << f; puts f}

  s.homepage    = 'https://www.github.com'
  s.license     = 'MIT'
 # s.required_ruby_version = '~> 2.0'
end
