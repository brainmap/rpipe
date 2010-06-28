require 'helper_spec'
require 'logfile'
require 'pp'
require 'yaml'

describe "Test Logfile Helper" do
	before(:all) do
	  @fixture_prefix = 'faces3_recognitionA'
	  @fixture_prefix_combined = 'faces3_recognitionB_incmisses'
	  @temp_prefix = 'temp_faces3_recog'
	  
	  @textfile = File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.txt')
	  @textfile_combined = File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix_combined + '.txt')
	  @csvfile_equal =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '_equal.csv')
	  @csvfile_unequal =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '_unequal.csv')
	  @matfile =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.mat')
	  
	  @equal_length_conditions = [:new, :old]
	  @unequal_length_conditions = [:new_correct, :new_incorrect, :old_correct, :old_incorrect]
	  @collapseable_conditions = [:new_correct, :new_incorrect, :new_misses, :old_correct, :old_incorrect, :old_misses]
	  
	  @ruport_summary = YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'ruport_summary.yml'))
  end
	  
  it "should take a text file with vectors of equal length and convert it to a condition csv" do 
    log = Logfile.new(@textfile, *@equal_length_conditions)
    puts log.to_csv
    log.write_csv(@temp_prefix + '.csv')
    File.exist?(@temp_prefix + '.csv').should be_true
  end
	
	it "should take a text file with vectors of unequal length and convert it to a condition csv" do 
	  log = Logfile.new(@textfile, *@unequal_length_conditions)
	  puts log.to_csv
	  log.write_csv(@temp_prefix + '.csv')
	  File.exist?(@temp_prefix + '.csv').should be_true
	  pp log.vectors.values
	  log.vectors.values.transpose.should have_at_least(10).lines
	end
	
	it "should combine logfile vectors" do 
	  log = Logfile.new(@textfile, *@collapseable_conditions)
	  log.combine_vectors(:misses, [:new_misses, :old_misses])
	  log.write_csv(@temp_prefix + '.csv')
	  File.exist?(@temp_prefix + '.csv').should be_true
	  pp log.vectors
	  log.vectors.values.transpose.should have_at_least(10).lines
	end
	
  
  it "should take a condition csv with vectors of equal length and convert it to multiple conditions file" do
    log = Logfile.new(@textfile, *@equal_length_conditions)
    log.csv_filename = @csvfile_equal # Use CSV Fixture to test only multiple conditions creation.
    log.write_mat(@temp_prefix)
    File.exist?(@temp_prefix + '.mat').should be_true
  end
  
  it "should take a condition csv with vectors of unequal length and convert it to multiple conditions file" do
    log = Logfile.new(@textfile, *@unequal_length_conditions)
    log.csv_filename = @csvfile_unequal
    log.write_mat(@temp_prefix)
    File.exist?(@temp_prefix + '.mat').should be_true
  end
  
  it "should sort logfiles based on file creation time" do
    [Logfile.new(@textfile), Logfile.new(@textfile)].sort
  end
  
  it "should raise an error if the logfile can't be found" do
    lambda { Logfile.new('bad_path_to_logfile.csv')}.should raise_error(IOError) 
  end
  
  it "should summarize a directory of logfiles" do
    summary = Logfile.summarize_directory(File.join(File.dirname(__FILE__), 'fixtures'))
    summary.column_names.should == ["enum", "task", "version", "ctime", "Total Count", " Hits", " Misses", " Hit%", " Correct", " Incorrect", " Accuracy%", " RT min", " RT max", " RT avg", " RT stdev", " old_stimuli", " old_hits", " old_misses", " old_hit_percent", " old_correct_count", " old_incorrect_count", " old_accuracy", " old_rt_min", " old_rt_max", " old_rt_avg", " old_rt_stdev", " old_correct", " old_correct_rt_min", " old_correct_rt_max", " old_correct_rt_avg", " old_correct_rt_stdev", " old_incorrect", " old_incorrect_rt_min", " old_incorrect_rt_max", " old_incorrect_rt_avg", " old_incorrect_rt_stdev", " new_stimuli", " new_hits", " new_misses", " new_hit_percent", " new_correct_count", " new_incorrect_count", " new_accuracy", " new_rt_min", " new_rt_max", " new_rt_avg", " new_rt_stdev", " new_correct", " new_correct_rt_min", " new_correct_rt_max", " new_correct_rt_avg", " new_correct_rt_stdev", " new_incorrect", " new_incorrect_rt_min", " new_incorrect_rt_max", " new_incorrect_rt_avg", " new_incorrect_rt_stdev", " "]
    summary.length.should == 2
    summary.data == @ruport_summary.data
  end
    
  after(:each) do
    ['.txt', '.csv', '.mat'].each do |ext| 
      File.delete(@temp_prefix + ext) if File.exist?(@temp_prefix + ext)
    end
  end
end