########################################################################################################################
# A class for parsing a data directory and creating Job Specs
class JobGenerator
  # Configuration details are put in a spec hash and used to drive processing.
  attr_reader :spec
  # The spec hash of a previous step (i.e. the recon hash to build a preprocessing hash on.)
  attr_reader :previous_step
  
  # Intialize spec and previous step and set job defaults.
  def initialize(config = {})
    @spec = {}
    config_defaults = {}
    @config = config_defaults.merge(config)
    
    @previous_step = @config['previous_step']
    @spec['method'] = @config['method'] if @config['method']
  end
  
  def config_requires(*args)
    missing_args = [*args.collect { |arg| arg unless @config.has_key?(arg) }].flatten.compact
    unless missing_args.empty?
      raise DriverConfigError, "Missing Configuration for: #{missing_args.join(', ')}"
    end      
  end
  
  def spec_validates(*args)
    invalid_args = [*args.collect{ |arg| arg if eval("@spec['#{arg}'].nil?")  }].flatten.compact
    unless invalid_args.empty?
      raise DriverConfigError, "Job could not create: #{invalid_args.join(', ')}"
    end
  end
  
end

# Raised when a JobGenerator class is missing required information.
class DriverConfigError < ScriptError; end