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
    @commands.flatten.join('; ')
  end
  
  def run!
    set_matlabpath
    cmd = @ml_command + " -r \"#{ to_s }; exit\" "
    @success = run(cmd)
  end
  
  def method_missing(m, *args, &block)
    @commands.send(m, *args, &block)
  end
  
  # Add paths that should be available for Matlab scripts.
  def add_to_path(*args)
    args.each { |arg| @paths << arg }
  end
  
  private 
  
  # Ensure all the paths from #MatlabQueue @paths instance var are present. 
  def set_matlabpath
    mlpath = ENV['MATLABPATH'].split(":")
    @paths.flatten.collect { |path| mlpath << path }
    puts ENV['MATLABPATH'] = mlpath.uniq.join(":")
  end
  
end
