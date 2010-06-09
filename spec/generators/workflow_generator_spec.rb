require 'helper_spec'
# require 'rpipe'
require 'generators/workflow_generator'
require 'generators/recon_job_generator'
require 'generators/preproc_job_generator'

describe "Workflow Generator" do
	before(:each) do
    @rawdir = File.join(File.dirname(__FILE__), '..', 'fixtures', 'rawdata', 'mrt00015', 'dicoms')
    
    @valid_job_params = {
	    "scans" => [{
  	    "label"=>"task1",
  	    "dir"=>"s07_epi",
  	    "z_slices"=>36, 
  	    "rep_time"=>2.0, 
  	    "type"=>"func", 
  	    "physio_files"=> {
  	      :phys_directory       =>  "../cardiac",  # Relative to rawdir
  	      :series_description   =>  "EPI  fMRI Task1", 
  	      :respiration_signal   =>  "RESPData_epiRT_0211201009_21_22_80", 
  	      :respiration_trigger  =>  "RESPTrig_epiRT_0211201009_21_22_80", 
  	      :cardiac_signal       =>  "PPGData_epiRT_0211201009_21_22_80", 
  	      :cardiac_trigger      =>  "PPGTrig_epiRT_0211201009_21_22_80"
  	    }, 
  	    "bold_reps"=>167, 
  	    "task"=>"Faces3B"
	    }]
	  }
	  
	  @valid_workflow_spec = {
      "subid"     => "mrt00015",
      "rawdir"    => @rawdir,
      "origdir"   => Dir.mktmpdir('orig_'),
	    "procdir"   => Dir.mktmpdir('proc_'),
	    "statsdir"  => Dir.mktmpdir('stats_'),
      "collision" => "destroy",
      "jobs"      => [{"step" => "reconstruct"}.merge(@valid_job_params)]
    }
	  
    # @valid_pipe = RPipe.new(@valid_workflow_spec)
  end
  
  it "should be validated by RPipe" do
    pp workflow = WorkflowGenerator.new(@rawdir).build
    # .should == @valid_workflow_spec
    # RPipe.new(workflow).should == @valid_pipe
  end
  
  after(:each) do
    FileUtils.rm_r([@valid_workflow_spec['origdir'], @valid_workflow_spec['procdir'], @valid_workflow_spec['statsdir']])
  end
  
  
end