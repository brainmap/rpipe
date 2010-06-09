$LOAD_PATH.unshift('/Data/home/erik/code/physionoise/lib/')

require 'helper_spec'
require 'physiospec'


describe "Test Phyiosnoise" do
	before(:each) do
	  job_params = {
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
	  
	  workflow_spec = {
      "subid"=>"mrt00001",
      "rawdir"=>"/Data/vtrak1/raw/test/fixtures/rpipe/mrt00015/dicoms/",
      "origdir"=>   Dir.mktmpdir('orig_'),
	    "procdir"=>   Dir.mktmpdir('proc_'),
	    "statsdir"=>  Dir.mktmpdir('stats_'),
      "collision"=> "destroy"
    }
          
	  @recon_job = Reconstruction.new(workflow_spec, job_params)
    @scan_spec = @recon_job.scans.first
    
    @physionoise_fixture_dir = File.join(File.dirname(__FILE__), 'fixtures', 'physionoise_regressors')
	  
  end
	  
  it "should create physionoise regressors from Cardiac and Respiration Data" do
    Dir.chdir @recon_job.origdir do
      @recon_job.create_physiosnoise_regressors(@scan_spec)
    end
      
    Dir.compare_directories(@recon_job.origdir, @physionoise_fixture_dir).should be_true    

  end
  
  it "should build a 3dRetroicor string" do
    valid_cmd = "3dretroicor -prefix ptask1.nii -card /Data/vtrak1/raw/test/fixtures/rpipe/mrt00015/dicoms/../cardiac/PPGData_epiRT_0211201009_21_22_80 -resp /Data/vtrak1/raw/test/fixtures/rpipe/mrt00015/dicoms/../cardiac/RESPData_epiRT_0211201009_21_22_80 task1.nii"
    valid_outfile = "p#{@scan_spec['label']}.nii"
    test_cmd, test_outfile = @recon_job.build_retroicor_cmd(@scan_spec['physio_files'], "#{@scan_spec['label']}.nii")
    
    valid_cmd.should == test_cmd
    valid_outfile.should == test_outfile
  end

  after(:each) do
    FileUtils.rm_r([@recon_job.origdir, @recon_job.procdir, @recon_job.statsdir])
  end
end