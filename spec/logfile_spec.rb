require 'helper_spec'
require 'logfile'
require 'pp'

describe "Test Logfile Helper" do
	before(:all) do
	  @fixture_prefix = 'faces3_recognitionA'
	  @temp_prefix = 'temp_faces3_recogA'
	  
	  @textfile = File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.txt')
	  @csvfile_equal =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '_equal.csv')
	  @csvfile_unequal =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '_unequal.csv')
	  @matfile =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.mat')
	  
	  @equal_length_conditions = [:new, :old]
	  @unequal_length_conditions = [:new_correct, :new_incorrect, :old_correct, :old_incorrect]
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
    
  after(:each) do
    ['.txt', '.csv', '.mat'].each do |ext| 
      File.delete(@temp_prefix + ext) if File.exist?(@temp_prefix + ext)
    end
  end
end