require 'tmpdir'
require 'pathname'

########################################################################################################################
# A class for parsing a data directory and creating default Driver Configurations
class WorkflowGenerator
  attr_reader :spec
  
  def initialize(rawdir, config = Hash.new)
    @rawdir = File.expand_path(rawdir)
    config_defaults = {
      'processing_dir' => Dir.mktmpdir
    }
    @config = config_defaults.merge(config)
    @spec = Hash.new
  end
  
  def build
    @spec['rawdir'] = @rawdir
    
    subject_basename = File.basename(@rawdir) == 'dicoms' ? 
      File.basename(Pathname.new(File.join(@rawdir, '..')).realpath) : File.basename(@rawdir)
      
    subid = subject_basename.split('_').first
    @spec['subid'] = subid
    
    processing_dir = @config['processing_dir']
    @spec['origdir']  = File.join(processing_dir, subid + '_orig')
    @spec['procdir']  = File.join(processing_dir, subid + '_proc')
    @spec['statsdir'] = File.join(processing_dir, subid + '_stats')
    
    @spec['collision'] = 'destroy'
    
    jobs = []
    jobs << ReconJobGenerator.new({'rawdir' => @rawdir}).build
    jobs << PreprocJobGenerator.new(jobs.last, {'method' => 'Merit220Preprocess'}).build
    
    @spec['jobs'] = jobs
    
    return @spec
  end
end
