require 'metamri'
require 'generators/job_generator'

########################################################################################################################
# A class for parsing a data directory and creating a default Reconstruction Job
class ReconJobGenerator < JobGenerator
  def initialize(config)
    @spec = Hash.new
    @spec['step'] = 'reconstruct'
    
    config_defaults = {}
    config_defaults['epi_pattern'] = /fMRI/i
    @config = config_defaults.merge(config)
    
    @rawdir = config['rawdir']
    
    raise IOError, "Can't find raw directory #{@rawdir}" unless File.readable?(@rawdir)
  end
  
  def build
    scans = Array.new
    
    visit = VisitRawDataDirectory.new(@rawdir)
    visit.scan
    
    visit.datasets.each do |dataset|
      # Only build hashes for EPI datasets
      next unless dataset.series_description =~ @config['epi_pattern']
      
      scans << build_scan_hash(dataset)
    end
    
    @spec['scans'] = scans
    
    return @spec
  end
  
  # Returns a hash describing how to reconstruct the dataset.
  def build_scan_hash(dataset)
    scan = {}
    raw_image_file    = dataset.raw_image_files.first
    # phys = Physionoise.new(@rawdir, File.join(@rawdir, '..', 'cardiac' ))
    
    scan['dir']       = dataset.relative_dataset_path
    scan['type']      = 'func'
    scan['z_slices']  = raw_image_file.num_slices
    scan['bold_reps'] = raw_image_file.bold_reps
    scan['rep_time']  = raw_image_file.rep_time
    scan['label']     = dataset.series_description.escape_filename
    scan['task']      = '?'
    scan['physio_files']  = "#TODO"
    
    return scan
  end
end