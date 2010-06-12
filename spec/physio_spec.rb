$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../physionoise/lib'))

require 'helper_spec'
require 'rpipe'
require 'physionoise'


describe "Test Phyiosnoise" do
	before(:each) do
	  @runs_dir = File.join($MRI_DATA, 'mrt00000', 'dicoms')
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
      "subid"=>"mrt00000",
      "rawdir"=>    @runs_dir,
      "origdir"=>   Dir.mktmpdir('orig_'),
	    "procdir"=>   Dir.mktmpdir('proc_'),
	    "statsdir"=>  Dir.mktmpdir('stats_'),
      "collision"=> "destroy"
    }
    
    @valid_physionoise_run_spec = [{
      :run_directory=> @runs_dir, 
      :bold_reps=>167, :respiration_signal=>"RESPData_epiRT_0211201009_21_22_80", 
      :respiration_trigger=>"RESPTrig_epiRT_0211201009_21_22_80", 
      :cardiac_signal=>"PPGData_epiRT_0211201009_21_22_80", 
      :cardiac_trigger=>"PPGTrig_epiRT_0211201009_21_22_80", 
      :phys_directory=> File.join(@runs_dir, '..', 'cardiac'), 
      :rep_time=>2.0, 
      :series_description=>"EPI  fMRI Task1"
    }]
          
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
  
  it "should correctly build a spec for passing to physionoise" do
    @recon_job.build_physionoise_run_spec(@scan_spec).should == @valid_physionoise_run_spec
  end
  
  it "should correctly build a physionoise python command" do
      @valid_physionoise_run_spec.each do |run|
        puts Physionoise.build_run_cmd(run)
      end
  end
  
  it "should build a 3dRetroicor string" do
    valid_cmd = "3dretroicor -prefix ptask1.nii -card #{@runs_dir}/../cardiac/PPGData_epiRT_0211201009_21_22_80 -resp #{@runs_dir}/../cardiac/RESPData_epiRT_0211201009_21_22_80 task1.nii"
    valid_outfile = "p#{@scan_spec['label']}.nii"
    test_cmd, test_outfile = @recon_job.build_retroicor_cmd(@scan_spec['physio_files'], "#{@scan_spec['label']}.nii")
    
    valid_cmd.should == test_cmd
    valid_outfile.should == test_outfile
  end

  after(:each) do
    FileUtils.rm_r([@recon_job.origdir, @recon_job.procdir, @recon_job.statsdir])
  end
end