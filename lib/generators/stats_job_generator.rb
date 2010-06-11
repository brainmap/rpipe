require 'generators/job_generator'
require 'logfile'

########################################################################################################################
# A class for parsing a data directory and creating a default Stats Job
# Intialize a StatsJobGenerator with a config hash including the following optional keys:
#
# - subid : SubjectID (i.e. 'mrt00015') 
# - conditions : An array of condition names for analysis.
# - scans : A hash containing scan information (labels, bold_reps, etc.)

class StatsJobGenerator < JobGenerator
  def initialize(config = {})
    config_defaults = {}
    config_defaults['epi_task_pattern'] = /Task/i
    config_defaults['regressors_prefix'] = 'rp_a'
    super config_defaults.merge(config)
    
    @spec['step'] = 'stats'

    config_requires 'scans', 'subid', 'conditions'
    
    @scans = []
    @config['scans'].each { |scan| @scans << scan if scan['label'] =~ @config['epi_task_pattern'] }
    
  end
  
  def build
    @spec['bold_reps']        = bold_reps
    @spec['responses']        = responses
    @spec['conditions']       = @config['conditions']
    @spec['regressorsfiles']  = regressorsfiles
    return @spec 
  end
  
  def bold_reps
    return @bold_reps if @bold_reps
    bold_reps = []
    @scans.collect {|scan| scan['bold_reps'] - scan['volumes_to_skip']}
  end
  
  # A getter/builder method for behavioural responses.
  def responses
    return @responses if @responses
    @responses = {}
    @responses['directory'] = Pathname.new(File.join(File.dirname(__FILE__), '..', '..', 'test', 'fixtures', 'rawdata', 'responses')).cleanpath.to_s
    @responses['logfiles'] = logfiles

    return @responses
  end
  
  def logfiles
    return @logfiles if @logfiles
    logfiles = Dir.glob(File.join(@responses['directory'], @config['subid'] + "*.txt"))
    raise IOError, "No logfiles found in #{@responses['directory']} matching #{@config['subid']}" if logfiles.empty?
    logfiles = logfiles.collect! {|file| Logfile.new(file)}.sort
    @logfiles = logfiles.collect! {|file| File.basename(file.textfile) }
  end
  
  def regressorsfiles
    return @regressorsfiles if @regressorsfiles
    regressorsfiles = []
    @regressorsfiles = @scans.collect {|scan| "%s%s_%s.txt" % [ @config['regressors_prefix'], @config['subid'], scan['label'] ]}
  end
  
  def valid?
    spec_validates 'regressorsfiles', 'responses'
  end
  
end