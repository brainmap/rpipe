require 'helper_spec'
require 'generators/workflow_generator'

describe "Workflow Generator" do
	before(:each) do
	  @fixtures_dir = File.join File.dirname(__FILE__), '..', 'fixtures'
	  @drivers_dir  = File.join File.dirname(__FILE__), '..', 'drivers'
    @workflow_driver = YAML.load_file(File.join @drivers_dir, 'merit220_workflow_sample.yml')
    @rawdir = File.join $MRI_DATA, 'johnson.merit220.visit1', 'mrt00000', 'dicoms'
    @scans = YAML.load_file(File.join @fixtures_dir, 'valid_scans.yaml')
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
	  
	  @origdir  = Dir.mktmpdir('orig_')
	  @procdir  = Dir.mktmpdir('proc_')
	  @statsdir = Dir.mktmpdir('stats_')
	  
	  @valid_workflow_spec = {
      "study_procedure" => "johnson.merit220.visit1",
      "subid"     => "mrt00000",
      "rawdir"    => @rawdir,
      "origdir"   => @origdir,
	    "procdir"   => @procdir,
	    "statsdir"  => @statsdir,
      "collision" => "destroy",
      "jobs"      => @valid_job_params
    }
	  
	  @valid_workflow_options = {
	    'responses_dir' => File.join($MRI_DATA, 'responses')
	  }.merge @workflow_driver
    # @valid_pipe = RPipe.new(@valid_workflow_spec)
    
    @valid_directory_format = "/Data/vtrak1/preprocessed/visits/johnson.merit220.visit1/<subid>/fmri/orig"
    @valid_multiple_substitution_directory_format = "/Data/vtrak1/preprocessed/visits/<study_procedure>/<subid>/fmri/orig"
  end
  
  it "should be valid when assigned known directories without study procedure." do
    options = @valid_workflow_options.merge(
    {'origdir' => @origdir, 'procdir' => @procdir, 'statsdir' => @statsdir})
    options.delete('study_procedure')
    options
      
    pp workflow = WorkflowGenerator.new(@rawdir, options).build
    workflow.should == @valid_workflow_spec
  end
  
  it "should parse directory format with one substitution" do
    workflow = WorkflowGenerator.new(@rawdir, @valid_workflow_options)
    dir = workflow.parse_directory_format(@valid_directory_format)
    dir.should == "/Data/vtrak1/preprocessed/visits/johnson.merit220.visit1/#{@valid_workflow_spec['subid']}/fmri/orig"
  end
  
  it "should parse directory format with multiple substitutions" do
    workflow = WorkflowGenerator.new(@rawdir, @valid_workflow_options)
    dir = workflow.parse_directory_format(@valid_multiple_substitution_directory_format)
    dir.should == "/Data/vtrak1/preprocessed/visits/#{@valid_workflow_spec['study_procedure']}/#{@valid_workflow_spec['subid']}/fmri/orig"    
  end
  
  it "should parse directory format when directories are not explicitly given" do
    pp options = @valid_workflow_options.dup.delete_if{|key, val| %w{origdir procdir statsdir}.include? key }
    workflow = WorkflowGenerator.new(@rawdir, options)
    dir = workflow.parse_directory_format(@valid_directory_format)
    dir.should == "/Data/vtrak1/preprocessed/visits/#{@valid_workflow_spec['study_procedure']}/#{@valid_workflow_spec['subid']}/fmri/orig"    
  end
  
  it "should guess a properly formed study procedure directory" do
    workflow = WorkflowGenerator.new(@rawdir, @valid_workflow_options)
    workflow.guess_study_procedure_from(@rawdir).should == 'johnson.merit220.visit1'
  end
  
  it "should raise a ScriptError if study procedure directory cannot be guessed" do
    workflow = WorkflowGenerator.new(@rawdir, @valid_workflow_options)
    lambda {workflow.guess_study_procedure_from('/bad/study/directory')}.should raise_error ScriptError, /Could not guess/
  end
  
  after(:each) do
    FileUtils.rm_r([@valid_workflow_spec['origdir'], @valid_workflow_spec['procdir'], @valid_workflow_spec['statsdir']])
  end
  
  
end