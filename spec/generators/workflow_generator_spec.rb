require 'helper_spec'
require 'generators/workflow_generator'

describe "Workflow Generator" do
	before(:each) do
    @rawdir = File.join($MRI_DATA, 'mrt00000', 'dicoms')
    @scans = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'fixtures', 'valid_scans.yaml'))
    rootdir = Pathname.new(File.join(File.dirname(__FILE__), '..', '..')).realpath.to_s
    @valid_recon_job_spec = {"step"=>"reconstruct", "scans"=> @scans}
    @valid_preproc_job_spec = {"step"=>"preprocess", "bold_reps"=>[164, 164, 164]}
    @valid_stats_job_spec = {
      "step"=>"stats",
      "responses"=> {
        "logfiles" => ["mrt00000_abc_01012010_faces3_recognitionB.txt", "mrt00000_abc_01012010_faces3_recognitionA.txt"],
        "directory"=> File.join($MRI_DATA, 'responses')
      },
      "conditions"=> ["new_correct", "new_incorrect", "old_correct", "old_incorrect"],
      "regressorsfiles"=> ["rp_amrt00000_EPI-fMRI-Task1.txt", "rp_amrt00000_EPI-fMRI-Task2.txt"],
      "bold_reps"=>[164, 164]
    }
    
    
    @valid_job_params = [@valid_recon_job_spec, @valid_preproc_job_spec, @valid_stats_job_spec]	  
	  
	  @origdir = Dir.mktmpdir('orig_')
	  @procdir = Dir.mktmpdir('proc_')
	  @statsdir = Dir.mktmpdir('stats_')
	  
	  @valid_workflow_spec = {
      "subid"     => "mrt00000",
      "rawdir"    => @rawdir,
      "origdir"   => @origdir,
	    "procdir"   => @procdir,
	    "statsdir"  => @statsdir,
      "collision" => "destroy",
      "jobs"      => @valid_job_params
    }
	  
	  @valid_workflow_options = {'responses_dir' => File.join($MRI_DATA, 'responses')}
    # @valid_pipe = RPipe.new(@valid_workflow_spec)
  end
  
  it "should be valid when assigned known directories." do
    workflow = WorkflowGenerator.new(@rawdir, @valid_workflow_options.merge(
      {'origdir' => @origdir, 'procdir' => @procdir, 'statsdir' => @statsdir})).build
    workflow.should == @valid_workflow_spec
  end
  
  after(:each) do
    FileUtils.rm_r([@valid_workflow_spec['origdir'], @valid_workflow_spec['procdir'], @valid_workflow_spec['statsdir']])
  end
  
  
end