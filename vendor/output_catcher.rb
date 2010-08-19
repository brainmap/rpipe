=begin rdoc

= OutputCatcher

by Matthias Hennemeyer <mhennemeyer@gmail.com>

== Introduction

OutputCatcher is available as a Rails plugin and as a gem.
It provides a way to capture the standard out($stdout) or standard error($stderr) of your code without pain
and suppresses the output of the 'err' or 'out' stream.


== Usage

  OutputCatcher knows only two methods: .catch_err and .catch_out

  To capture the stderr of your code:

  err = OutputCatcher.catch_err do
    $stderr << "error error"
  end
  err #=> "error error"


  To capture the stdout of your code:

  out = OutputCatcher.catch_out do
    puts "Hello Hello"
  end
  out #=> "Hello Hello"

== INSTALL:
Rails:

  $ ruby script/plugin install git://github.com/mhennemeyer/output_catcher.git

Gem:

  $ gem install mhennemeyer-output_catcher


Copyright (c) 2008 Matthias Hennemeyer, released under the MIT license

=end

require 'stringio'

class OutputCatcher
  class << self
    
    def catch_io(post, &block)
      original = eval("$std" + post)
      fake = StringIO.new
      eval("$std#{post} = fake")
      begin
        yield
      ensure
        eval("$std#{post} = original")
      end
      fake.string
    end
    
    def catch_out(&block)
      catch_io("out", &block)
    end
    
    def catch_err(&block)
      catch_io("err", &block)
    end
    
  end
end

class Tee < IO
  FILE_DESC = {:in => 0, :out => 1, :err => 2}
  
  def initialize(filename, post = :out, mode_string = 'w')
    super(FILE_DESC[post], mode_string)
    @file = File.open(filename, mode_string)
    eval("$std#{post} = self")
  end
  
  def write(string)
    STDOUT.write string
    @file.puts string
    @file.flush
  end
  
  def self.open(filename, post, mode_string, &block)
    
  end
end