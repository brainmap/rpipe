require 'tmpdir'
require 'pathname'

require 'core_additions'
require 'generators/recon_job_generator'
require 'generators/preproc_job_generator'
require 'generators/stats_job_generator'

########################################################################################################################
# A class for parsing a data directory and creating default Driver Configurations
# Intialize a WorkflowGenerator with a Raw Directory containing Scans
# and with the following optional keys in a config hash:
#
# Directory Options:
#  - processing_dir : A directory common to  orig, proc and stats directories, if they are not explicitly specified..
#  - origdir : A directory where dicoms will be converted to niftis and basic preprocessing occurs.
#  - procdir : A directory for detailed preprocessing (normalization and smoothing)
#  - statsdir : A directory where stats will be saved.  (This should be a final directory.)

class WorkflowGenerator < JobGenerator
  attr_reader :spec
  
  def initialize(rawdir, config = Hash.new)
    config_defaults = {}
    config_defaults['conditions'] = ['new_correct', 'new_incorrect', 'old_correct', 'old_incorrect']
    config_defaults['processing_dir'] = Dir.mktmpdir
    super config_defaults.merge(config)
    
    @rawdir = rawdir
    @spec['rawdir'] = @rawdir
    @spec['subid'] = parse_subid
    @spec['study_procedure'] = @config['study_procedure'] ||= guess_study_procedure_from(@rawdir)

    # config_requires 'responses_dir'
  end
  
  # Create and return a workflow spec to drive processing
  def build    
    configure_directories
    
    @spec['collision'] = 'destroy'
    
    
    jobs = []
    
    # Recon
    recon_options = {'rawdir' => @rawdir, 'epi_pattern' => /(Resting|Task)/i, }
    config_step_method(recon_options, 'recon') if @config['custom_methods']
    jobs << ReconJobGenerator.new(recon_options).build
    
    # Preproc
    preproc_options = {'scans' => jobs.first['scans']}
    config_step_method(preproc_options, 'preproc') if @config['custom_methods']
    jobs << PreprocJobGenerator.new(preproc_options).build
    
    # Stats
    stats_options = {
      'scans' => jobs.first['scans'],
      'conditions' => @config['conditions'],
      'responses_dir' => @config['responses_dir'],
      'subid' => @spec['subid']
    }
    config_step_method(stats_options, 'stats') if @config['custom_methods']
    jobs << StatsJobGenerator.new(stats_options).build
    
    @spec['jobs'] = jobs
    
    return @spec
  end
  
  # Guesses a Subject Id from @rawdir
  # Takes the split basename of rawdir itself if rawdir includes subdir, or
  # the basename of its parent.
  def parse_subid
    subject_path = File.basename(@rawdir) == 'dicoms' ? 
      Pathname.new(File.join(@rawdir, '..')).realpath : Pathname.new(@rawdir).realpath
    
    subject_path.basename.to_s.split('_').first
  end
  
  # Handle Directory Configuration and Defaults for orig, proc and stats dirs.
  def configure_directories
    processing_dir = @config['processing_dir']
    @spec['origdir']  = @config['origdir']  || parse_directory_format(@config['directory_formats']['origdir'])  || File.join(processing_dir, @spec['subid'] + '_orig')
    @spec['procdir']  = @config['procdir']  || parse_directory_format(@config['directory_formats']['procdir'])  || File.join(processing_dir, @spec['subid'] + '_proc')
    @spec['statsdir'] = @config['statsdir'] || parse_directory_format(@config['directory_formats']['statsdir']) || File.join(processing_dir, @spec['subid'] + '_stats')
  end
  
  # Replace a directory format string with respective values from the spec.
  # For example, replace the string "/Data/<study_procedure>/<subid>/stats" from
  # a workflow_driver['directory_formats']['statsdir'] with 
  # "/Data/johnson.merit220.visit1/mrt00000/stats"
  def parse_directory_format(fmt)
    dir = fmt.dup
    dir.scan(/<\w*>/).each do |replacement|
      key = replacement.to_s.gsub(/(<|>)/, '')
      dir.sub!(/<\w*>/, @spec[key])
    end
    return dir
  end
  
  # Guess a StudyProcedure from the data's raw directory.
  # A properly formed study procdure should be: <PI>.<Study>.<Description or Visit>
  # Raises a ScriptError if it couldn't guess a reasonable procedure.
  def guess_study_procedure_from(dir)
    dirs = dir.split("/")
    while dirs.empty? == false do
      current_dir = dirs.pop
      return current_dir if current_dir =~ /\w*\.\w*\.\w*/
    end
    raise ScriptError, "Could not guess study procedure from #{dir}"
  end
  
  # Configure Custom Methods from the Workflow Driver
  #
  # Custom methods may be simply set to true for a given job or listed 
  # explicitly.  If true, they will set the method to the a camelcased version
  # of the study_procedure and step, i.e. JohnsonMerit220Visit1Stats
  # If listed explicitly, it will set the step to the value listed.
  def config_step_method(options, step)
    if @config['custom_methods'][step].class == String
      options['method'] = @config['custom_methods'][step]
    elsif @config['custom_methods'][step] == true
      options['method'] = [@config['study_procedure'], step.capitalize].join("_").dot_camelize
    end
  end
    
end
