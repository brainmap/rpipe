###############################################	 START OF CLASS	 ######################################################
# An object that maintains and runs matlab jobs and paths.
class MatlabQueue
  attr_accessor :paths, :commands, :ml_command
  attr_reader :success
  
  def initialize
    @paths = []
    @commands = []
    @ml_command = "matlab -nosplash -nodesktop"
  end
  
  def to_s
    [
      @paths.flatten.collect {|path| "addpath(genpath('#{path}'))"},
      @commands
    ].flatten.join('; ')
  end
  
  def run!
    flash cmd = @ml_command + " -r \"#{ to_s }; exit\" "
    system(cmd)
    @success = ($? == 0) ? true : false
  end
  
  def method_missing(m, *args, &block)
    @commands.send(m, *args, &block)
  end
  
  def add_to_path(*args)
    args.each { |arg| @paths << arg }
  end
  
  def flash(msg)
		puts
	  puts sep = "+" * (msg.length + 4)
		printf "  %s\n", msg
		printf "  %s\n", Time.now
		puts sep
		puts
	end
end
###############################################	 END OF CLASS	 #########################################################
