require 'popen4'
require 'default_logger'
include DefaultLogger

unless defined?($Log)
  DefaultLogger::setup_logger
end

# Global Method to Log and Run system commands.
def run(command)
  $CommandLog.info command
  
  status = POpen4::popen4(command) do |stdout, stderr|
    puts stdout.read.strip
    $Log.error stderr.read.strip
  end
      
  status && status.exitstatus == 0 ? true : false
end

# Global Method to display a message and the date/time to standard output.
def flash(msg)
	$Log.info msg
end