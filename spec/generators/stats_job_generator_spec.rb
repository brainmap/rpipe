require 'helper_spec'
require 'generators/stats_job_generator'

describe "StatsJobGenerator creates a Stats Job Driver Spec" do
	before(:all) do
    @subid = 'mrt00015'
    @scans = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'fixtures', 'valid_scans.yaml'))
    rootdir = Pathname.new(File.join(File.dirname(__FILE__), '..', '..')).realpath.to_s
    @valid_stats_job_spec = {
      "step"=>"stats",
      "responses"=> {
        "logfiles" => ["mrt00015_faces3_recognitionB.txt", "mrt00015_faces3_recognitionA.txt"],
        "directory"=> Pathname.new(File.join(rootdir, 'test', 'fixtures', 'rawdata', 'responses')).cleanpath.to_s
      },
      "conditions"=> ["new_correct", "new_incorrect", "old_correct", "old_incorrect"],
      "regressorsfiles"=> ["rp_amrt00015_EPI-fMRI-Task1.txt", "rp_amrt00015_EPI-fMRI-Task2.txt"],
      "bold_reps"=>[164, 164]
    }
    
    @valid_options = {
      'conditions' => ['new_correct', 'new_incorrect', 'old_correct', 'old_incorrect'],
      'subid' => @subid,
      'scans' => @scans
    }
  end
  
  it "should create a valid job spec with no custom method" do
    stats_job_spec = StatsJobGenerator.new(@valid_options).build
    stats_job_spec.should == @valid_stats_job_spec
  end
  
  it "should create a valid job spec with a custom method defined" do
    valid_stats_job_spec = @valid_stats_job_spec.dup
    valid_stats_job_spec['method'] = 'Merit220Preprocess'
    stats_job_spec = StatsJobGenerator.new(@valid_options.merge({'method' => 'Merit220Preprocess'})).build
    stats_job_spec.should == valid_stats_job_spec
  end
  
    
  it "should raise a DriverConfigError if required keys are not specified." do
    missing_options = ['subid', 'scans', 'conditions'].collect do |key|
      @valid_options.dup.reject {|k,v| key == k }
    end
    missing_options.each do |options|
      lambda { StatsJobGenerator.new(options).build }.should raise_error DriverConfigError
    end
  end
    
end