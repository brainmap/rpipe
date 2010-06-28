require 'helper_spec'
require 'rpipe'

describe "Unit testing for johnson.merit220.visit1" do
  before(:each) do
    @driver_file = File.join(File.dirname(__FILE__), 'drivers', 'mrt00000.yml')
    @driver = YAML.load_file(@driver_file)
	  
    @driver['rawdir']   = File.join($MRI_DATA, 'mrt00000', 'dicoms')
    @driver['origdir']  = @origdir  = Dir.mktmpdir('orig_')
    @driver['procdir']  = @procdir  = Dir.mktmpdir('proc_')
    @driver['statsdir'] = @statsdir = Dir.mktmpdir('stats_')
    
    @valid_responses_options = {
      'directory' => File.join($MRI_DATA, 'responses'), 
      'logfiles' => [
        'mrt00000_abc_01012010_faces3_recognitionB.txt', 
        'mrt00000_abc_01012010_faces3_recognitionA.txt'
      ]
    }
    
    @valid_combine_options = {
      :combined_vector_title => :misses,
      :original_vector_titles => [:new_misses, :old_misses]      
    }
      
    @pipe = RPipe.new(@driver)
    @job = @pipe.stats_jobs.first
  end
    
  it "should convert logfiles into matfiles" do
    conditions = [:new_correct, :new_incorrect, :old_correct, :old_incorrect]
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        @job.onsetsfiles = @job.create_onsets_files(@valid_responses_options, conditions)
        @job.onsetsfiles.should_not be_nil
        @job.onsetsfiles.should == ["mrt00000_faces3_recognitionB.mat", "mrt00000_faces3_recognitionA.mat"]
        puts Dir.glob('*')
        @job.onsetsfiles.each do |onsetfile|
          File.exist?(onsetfile).should be_true
        end
      end
    end
  end
  
  it "should convert logfiles into matfiles including misses as a condition" do
    conditions = [:new_correct, :new_incorrect, :old_correct, :old_incorrect, :new_misses, :old_misses]
    
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        @job.onsetsfiles = @job.create_onsets_files(@valid_responses_options, conditions, @valid_combine_options)
        @job.onsetsfiles.should_not be_nil
        @job.onsetsfiles.should == ["mrt00000_faces3_recognitionB.mat", "mrt00000_faces3_recognitionA.mat"]
        puts Dir.glob('*')
        @job.onsetsfiles.each do |onsetfile|
          File.exist?(onsetfile).should be_true
        end
      end
    end
  end
  
  it "should raise a script error if neither log files nor mat files are configured." do
    @job.onsetsfiles = nil
    @job.responses = nil
    lambda { @job.run_first_level_stats }.should raise_error ScriptError
  end
  
  after(:each) do
    FileUtils.rm_r([@origdir, @procdir, @statsdir])
  end
end