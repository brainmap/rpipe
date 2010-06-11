require 'helper_spec'

describe "Integration Processing for Johnson.Merit220" do
  before(:all) do
    @driver_file = File.join(File.dirname(__FILE__), 'drivers', 'mrt00000.yml')
    @driver = YAML.load_file(@driver_file)	  
    @driver['rawdir']   = File.join(File.dirname(__FILE__), 'fixtures', 'rawdata', 'mrt00000', 'dicoms')
    @driver['origdir']  = @origdir  = Dir.mktmpdir('orig_')
    @driver['procdir']  = @procdir  = Dir.mktmpdir('proc_')
    @driver['statsdir'] = @statsdir = Dir.mktmpdir('stats_')
    @driver['jobs'][2]['responses']['directory'] = File.join(File.dirname(__FILE__), 'fixtures', 'rawdata', 'responses')
    @valid_responses_options = @driver['jobs'][2]['responses']
    @pipe = RPipe.new(@driver)
    @job = @pipe.stats_jobs.first
    
  end
  
  it "should reconstruct raw data" do
     pipe = RPipe.new(@driver)
     p = pipe.recon_jobs.first
     p.perform
   end
   
   it "should preprocess raw data" do
     pipe = RPipe.new(@driver)
     p = pipe.preproc_jobs.first
     p.perform
   end
  
  it "should run stats on processed data" do
    pipe = RPipe.new(@driver)
    s = pipe.stats_jobs.first
    s.perform
  end

end

