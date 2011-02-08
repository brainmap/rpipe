gem 'activeresource', '<=2.3.8'
$LOAD_PATH.unshift('~/projects/metamri/lib').unshift('~/code/metamri/lib')
require 'metamri'
require 'generators/job_generator'

########################################################################################################################
# A class for parsing a data directory and creating a default Reconstruction Job
# Intialize the ReconJobGenerator with the following options in a config hash.
# 
# Required Options:
# - rawdir : The directory containing EPI runs
#
# Raises an IOError if the Raw Directory cannot be read, and a 
# DriverConfigError if the Raw Directory is not specified.

class ReconJobGenerator < JobGenerator
  def initialize(config)
    # Add job-specific config defaults to config and initialize teh JobGenerator with them.
    config_defaults = {}
    config_defaults['epi_pattern'] = /fMRI/i
    config_defaults['ignore_patterns'] = [/pcasl/i]
    config_defaults['volumes_to_skip'] = 3
    super config_defaults.merge(config)

    @spec['step'] = 'reconstruct'

    config_requires 'rawdir'
    @rawdir = @config['rawdir']
    raise IOError, "Can't find raw directory #{@rawdir}" unless File.readable?(@rawdir)
  end
  
  def build
    scans = Array.new
    
    visit = VisitRawDataDirectory.new(@rawdir)
    # Scan the datasets, ignoring unwanted (very large unused) directories.
    visit.scan(:ignore_patterns => [@config['ignore_patterns']].flatten)
    
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
    
    scan['dir']             = dataset.relative_dataset_path
    scan['type']            = 'func'
    scan['z_slices']        = raw_image_file.num_slices.to_i
    scan['bold_reps']       = raw_image_file.bold_reps.to_i
    scan['volumes_to_skip'] = @config['volumes_to_skip'].to_i
    scan['rep_time']        = raw_image_file.rep_time.to_f.in_seconds
    scan['label']           = dataset.series_description.escape_filename
    # scan['task']            = '?'
    # scan['physio_files']    = "#TODO"
    
    return scan
  end
end

# Convert Milliseconds to Seconds for TRs
class Float
  def in_seconds
    self / 1000.0
  end
end