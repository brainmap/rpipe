require 'helper_spec'
require 'pp'

describe "Unit testing for johnson.merit220.visit1" do
  before(:all) do
    @driver_file = File.join(File.dirname(__FILE__), 'drivers', 'mrt00015.yml')
    @pipe = RPipe.new(@driver_file)
    @job = @pipe.stats_jobs.first
  end
    
  it "should convert logfiles into matfiles" do
    conditions = [:new_correct, :new_incorrect, :old_correct, :old_incorrect]
    @job.onsetsfiles = @job.create_onsets_files(@job.logresponsefiles, conditions)
    @job.onsetsfiles.should_not be_nil
    @job.onsetsfiles.should == ["mrt00015_faces3_recognitionB.mat", "mrt00015_faces3_recognitionA.mat"]
    @job.onsetsfiles.each do |onsetfile|
      File.exist?(onsetfile).should be_true
    end
  end
  
  it "should raise a script error if neither log files nor mat files are configured." do
    @job.onsetsfiles = nil
    @job.logresponsefiles = nil
    lambda { @job.run_first_level_stats }.should raise_error(ScriptError)    
  end
  
end