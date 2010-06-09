require 'generators/job_generator'

########################################################################################################################
# A class for parsing a data directory and creating a default Preprocessing Job
class PreprocJobGenerator < JobGenerator
  def initialize(recon_spec, config = {})
    @spec = Hash.new
    @spec['step'] = 'preprocess'
    
    @recon_spec = recon_spec
    
    config_defaults = {}
    config_defaults['volumes_to_skip'] = 3
    @config = config_defaults.merge(config)
    
    @spec['method'] = @config['method'] if @config['method']
  end
  
  # Build a job spec and return it.
  def build
    bold_reps = []
    @recon_spec['scans'].each do |scan|
      bold_reps << scan['bold_reps'] - @config['volumes_to_skip']
    end
    @spec['bold_reps'] = bold_reps
    
    return @spec
  end
end