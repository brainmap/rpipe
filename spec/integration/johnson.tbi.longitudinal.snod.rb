require File.join(File.dirname(__FILE__), '..', 'helper_spec')
require 'rpipe'

describe "Integration Processing for Johnson.Tbi.Longitudinal.Snod" do
  before(:all) do
    @driver_file = File.join(File.dirname(__FILE__), '..', 'drivers', 'tbi000.yml')

    # @driver['rawdir']   = File.join($MRI_DATA, 'johnson.tbi.longitudinal', 'tbi000', 'dicoms')
    # @driver['origdir']  = Dir.mktmpdir('orig_')
    # @driver['procdir']  = Dir.mktmpdir('proc_')
    # @driver['statsdir'] = Dir.mktmpdir('stats_')
    # @driver['jobs'][2]['responses']['directory'] = File.join($MRI_DATA, 'responses')
    # @valid_responses_options = @driver['jobs'][2]['responses']
    @pipe = RPipe.new(@driver_file)
    @driver = @pipe.workflow_spec
    # @job = @pipe.stats_jobs.first
    
    @completed_orig_directory = File.join($MRI_DATA, 'integration', 'tbi000_orig')
    @completed_proc_directory = File.join($MRI_DATA, 'integration', 'tbi000_proc')
    @completed_stats_directory = File.join($MRI_DATA, 'integration', 'tbi000_stats')
    
  end
  
  # it "should reconstruct raw data" do
  #   pipe = RPipe.new(@driver)
  #   pipe.recon_jobs.each do |recon_job|
  #     recon_job.perform
  #   end
  #   @origdir = @driver['origdir']
  #   Dir.compare_directories(@origdir, @completed_orig_directory)
  # end
   
  # it "should preprocess raw data" do
  #   @driver['origdir']  = @origdir || @completed_orig_directory
  #   pipe = RPipe.new(@driver)
  #   p = pipe.preproc_jobs.first
  #   p.perform
  #   @procdir = @driver['procdir']
  #   Dir.compare_directories(@procdir, @completed_proc_directory)    
  # end
  # 
  it "should run stats on processed data" do
    @driver['procdir'] = @procdir || @completed_proc_directory
    pipe = RPipe.new(@driver)
    s = pipe.stats_jobs.first
    s.perform
    @statsdir = @driver['statsdir']
    # Dir.compare_directories(@statsdir, @completed_stats_directory)
  end

end

