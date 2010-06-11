require 'helper_spec'
require 'generators/preproc_job_generator'

describe "PreprocJobGenerator creates a Preproc Job Driver Spec" do
	before(:all) do
    @scans = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'fixtures', 'valid_scans.yaml'))
    @valid_preproc_job_spec = {"step"=>"preprocess", "bold_reps"=>[164, 164, 164]}
  end
  
  it "should create a valid job spec with no custom method" do
    preproc_job_spec = PreprocJobGenerator.new({'scans' => @scans}).build
    preproc_job_spec.should == @valid_preproc_job_spec
  end
  
  it "should create a valid job spec with a custom method defined" do
    valid_preproc_job_spec = @valid_preproc_job_spec.dup
    valid_preproc_job_spec['method'] = 'Merit220Preprocess'
    preproc_job_spec = PreprocJobGenerator.new({'method' => 'Merit220Preprocess', 'scans' => @scans}).build
    preproc_job_spec.should == valid_preproc_job_spec
  end
  
    
  it "should raise a DriverConfigError if scans are not specified." do
    lambda { PreprocJobGenerator.new({}).build }.should raise_error DriverConfigError
  end
    
end