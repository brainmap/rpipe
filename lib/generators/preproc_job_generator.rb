require 'generators/job_generator'

########################################################################################################################
# A class for parsing a data directory and creating a default Preprocessing Job
# Intialize a PreprocJobGenerator with a config hash including the following optional keys:
#
# - scans : A hash of scans upon which to base preprocessing. 
#           Used to extract the correct bold reps for SPM.
#           See #ReconJobGenerator for options for the scans hash.
# 

class PreprocJobGenerator < JobGenerator
  def initialize(config = {})
    config_defaults = {}
    super config_defaults.merge(config)
    
    @spec['step'] = 'preprocess'
    
    config_requires 'scans'
  end
  
  # Build a job spec and return it.
  def build
    bold_reps = []
    @spec['bold_reps'] = @config['scans'].collect do |scan| 
      scan['bold_reps'] - scan['volumes_to_skip']
    end
    
    return @spec
  end
end