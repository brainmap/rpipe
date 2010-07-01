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
	  @combined_conditions = [:new_correct, :new_incorrect, :old_correct, :old_incorrect, {:misses => [:new_misses, :old_misses]}]
	  
	  @ruport_summary = YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'ruport_summary.yml'))
	  @correct_combined_vectors = {:old_correct=>[8.99945, 13.0001, 18.99695, 22.4986, 34.5006, 49.99595, 53.9966, 59.50275, 88.4972, 91.4998, 103.0028, 120.1117, 137.886, 141.88665, 147.41775], :old_incorrect=>[5.4978, 27.49735, 62.497, 72.50285, 105.99705], :misses=>[116.55185, 123.11425, 131.36515, 135.3575], :new_correct=>[0.0, 2.99425, 15.9938, 25.50115, 30.49995, 36.4968, 40.9965, 46.50265, 56.0011, 65.00055, 69.50025, 74.499, 77.5016, 79.99685, 85.50295, 96.9976, 100.9983, 110.5217, 113.02525, 144.9142, 151.91745, 155.91815, 158.4128], :new_incorrect=>[126.10855]}
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
  
  it "should raise an error if it could not set conditions when they are given" do
    lambda { Logfile.new(@textfile, nil) }.should raise_error(ScriptError, /Could not set conditions/i)
  end
  
  it "should summarize a directory of logfiles" do
    summary = Logfile.summarize_directory(File.join(File.dirname(__FILE__), 'fixtures'))
    summary.column_names.should == ["enum", "task", "version", "ctime", "Total Count", " Hits", " Misses", " Hit%", " Correct", " Incorrect", " Accuracy%", " RT min", " RT max", " RT avg", " RT stdev", " old_stimuli", " old_hits", " old_misses", " old_hit_percent", " old_correct_count", " old_incorrect_count", " old_accuracy", " old_rt_min", " old_rt_max", " old_rt_avg", " old_rt_stdev", " old_correct", " old_correct_rt_min", " old_correct_rt_max", " old_correct_rt_avg", " old_correct_rt_stdev", " old_incorrect", " old_incorrect_rt_min", " old_incorrect_rt_max", " old_incorrect_rt_avg", " old_incorrect_rt_stdev", " new_stimuli", " new_hits", " new_misses", " new_hit_percent", " new_correct_count", " new_incorrect_count", " new_accuracy", " new_rt_min", " new_rt_max", " new_rt_avg", " new_rt_stdev", " new_correct", " new_correct_rt_min", " new_correct_rt_max", " new_correct_rt_avg", " new_correct_rt_stdev", " new_incorrect", " new_incorrect_rt_min", " new_incorrect_rt_max", " new_incorrect_rt_avg", " new_incorrect_rt_stdev", " "]
    summary.length.should == 2
    summary.data == @ruport_summary.data
  end
  
  it "should extract combined conditions in a hash" do
    log = Logfile.new(@textfile_combined, *@combined_conditions)
    log.conditions.each {|condition| log.condition_vectors[condition.to_s].should == @correct_combined_vectors[condition.to_s] }
  end
    
  after(:each) do
    ['.txt', '.csv', '.mat'].each do |ext| 
      File.delete(@temp_prefix + ext) if File.exist?(@temp_prefix + ext)
    end
  end
end