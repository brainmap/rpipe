require 'helper_spec'
require 'rpipe'

describe "Integration Processing for Johnson.Tbi.Longitudinal.Snod" do
  before(:all) do
    @driver_file = File.join(File.dirname(__FILE__), '..', 'drivers', 'tbi000.yml')

    @pipe = RPipe.new(@driver_file)
    @driver = @pipe.workflow_spec
    
    @completed_orig_directory = File.join($MRI_DATA, 'integration', 'tbi000_orig')
    @completed_proc_directory = File.join($MRI_DATA, 'integration', 'tbi000_proc')
    @completed_stats_directory = File.join($MRI_DATA, 'integration', 'tbi000_stats')
    
  end
  
  it "should reconstruct raw data" do
    pipe = RPipe.new(@driver)

    # pipe.recon_jobs.first.perform
    pipe.recon_jobs.each do |recon_job|
      recon_job.perform
    end
    
    # Use instance variables to pass on local directories to subsequent tests if this one was successful.
    @origdir = @driver['origdir'] if Dir.compare_directories(@driver['origdir'], @completed_orig_directory)
  end
   
  it "should preprocess reconstructed data" do
    # Realignment alters the headers of images during Estimate, so you must
    # use a local copy that hasn't been run before for correct results.
    @driver['origdir']  = @origdir || Pathname.new(@completed_orig_directory).recursive_local_copy
    pipe = RPipe.new(@driver)
    p = pipe.preproc_jobs.first
    p.perform
    @procdir = @driver['procdir'] if Dir.compare_directories(@driver['procdir'], @completed_proc_directory)    
  end
  
  it "should run stats on processed data" do
    @driver['procdir'] = @procdir || @completed_proc_directory
    pipe = RPipe.new(@driver)
    s = pipe.stats_jobs.first
    s.perform
    @statsdir = @driver['statsdir'] if Dir.compare_directories(File.join(@driver['statsdir'], 'v1'), @completed_stats_directory)
  end

end

