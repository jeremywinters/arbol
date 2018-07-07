task :default => :test

task :test do
  require 'minitest'
  require 'minitest/ci'
  Dir.glob('./test/**/*_test.rb').each { |file| require file }
end