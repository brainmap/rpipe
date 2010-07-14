require 'default_logger'

# Maintain and run matlab commands and paths.
class MatlabQueue
  include DefaultLogger
  
  attr_accessor :paths, :commands, :ml_command
  attr_reader :success
  
  def initialize
    @paths = []
    @commands = []
    @ml_command = "matlab -nosplash -nodesktop"
    setup_logger
  end
  
  def to_s
    [
      @paths.flatten.collect {|path| "addpath(genpath('#{path}'))"},
      @commands
    ].flatten.join('; ')
  end
  
  def run!
    cmd = @ml_command + " -r \"#{ to_s }; exit\" "
    @success = run(cmd)
  end
  
  def method_missing(m, *args, &block)
    @commands.send(m, *args, &block)
  end
  
  def add_to_path(*args)
    args.each { |arg| @paths << arg }
  end
  
end
