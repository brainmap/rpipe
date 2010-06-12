require 'tmpdir'
require 'pathname'

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
    config_defaults['processing_dir'] = Dir.mktmpdir
    super config_defaults.merge(config)

    @rawdir = rawdir
    
    config_requires 'responses_dir'
  end
  
  def build
    @spec['rawdir'] = @rawdir
    @spec['subid'] = parse_subid
    
    processing_dir = @config['processing_dir']
    @spec['origdir']  = @config['origdir']  ||= File.join(processing_dir, @spec['subid'] + '_orig')
    @spec['procdir']  = @config['procdir']  ||= File.join(processing_dir, @spec['subid'] + '_proc')
    @spec['statsdir'] = @config['statsdir'] ||= File.join(processing_dir, @spec['subid'] + '_stats')
    
    @spec['collision'] = 'destroy'
    
    jobs = []
    jobs << ReconJobGenerator.new({'rawdir' => @rawdir}).build
    jobs << PreprocJobGenerator.new({'scans' => jobs.last['scans']}).build
    jobs << StatsJobGenerator.new({
      'scans' => jobs.first['scans'],
      'conditions' => ['new_correct', 'new_incorrect', 'old_correct', 'old_incorrect'],
      'responses_dir' => @config['responses_dir'],
      'subid' => @spec['subid']
    }).build
    
    @spec['jobs'] = jobs
    
    return @spec
  end
  
  def parse_subid
    subject_path = File.basename(@rawdir) == 'dicoms' ? 
      Pathname.new(File.join(@rawdir, '..')).realpath : Pathname.new(@rawdir).realpath
      
    subject_path.basename.to_s.split('_').first
  end
end
