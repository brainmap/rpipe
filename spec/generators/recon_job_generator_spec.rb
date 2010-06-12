require 'helper_spec'
require 'generators/recon_job_generator'

describe "Recon Job Generator creates a Recon Job Driver Spec" do
	before(:all) do
    @rawdir = File.join($MRI_DATA, 'mrt00000', 'dicoms')
    @scans = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'fixtures', 'valid_scans.yaml'))
    
    @valid_recon_job_spec = {
      "step"=>"reconstruct",
      "scans"=> @scans
    }
  end
  
  it "should create a valid job spec" do
    recon_job_spec = ReconJobGenerator.new({'rawdir' => @rawdir}).build
    recon_job_spec.should == @valid_recon_job_spec
  end
  
  it "should raise an IOError if the raw dir isn't found." do
    lambda { ReconJobGenerator.new({'rawdir' => '/bad/path/to/raw/dir'}).build }.should raise_error IOError
  end
  
  it "should raise a DriverConfigError if the raw dir isn't specified." do
    lambda { ReconJobGenerator.new({}).build }.should raise_error DriverConfigError
  end
  
  after(:all) do
    # FileUtils.rm_r([@valid_workflow_spec['origdir'], @valid_workflow_spec['procdir'], @valid_workflow_spec['statsdir']])
  end
  
  
end