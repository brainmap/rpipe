require 'log4r'

# Setup Command and General Logs to point to STDOUT if not defined.
module DefaultLogger
  def setup_logger
    %w{$Log $CommandLog}.each do |log|
      unless eval(log)
        eval("#{log} = Log4r::Logger.new('output')")
        eval("#{log}.add Log4r::StdoutOutputter.new(:stdout)")
      end
    end
  end
end