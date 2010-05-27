require 'spec_helper'
require 'logfile_helper'
require 'pp'

describe "Test Logfile Helper" do
	before(:all) do
	  @fixture_prefix = 'faces3_recognitionA'
	  @temp_prefix = 'temp_faces3_recogA'
	  
	  @textfile = File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.txt')
	  @csvfile =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.csv')
	  @matfile =  File.join(File.dirname(__FILE__), 'fixtures', @fixture_prefix + '.mat')
  end
	  
	it "should take a text file and convert it to a condition csv" do 
	  log = LogfileHelper.new(@textfile, :new, :old)
	  puts log.to_csv
	  log.write_csv(@temp_prefix + '.csv')
	  File.exist?(@temp_prefix + '.csv').should be_true
	end
	
  it "should take a condition csv and convert it to multiple conditions file" do
    log = LogfileHelper.new(@textfile, :new, :old)
    log.csv_filename = @csvfile # Use CSV Fixture to test only multiple conditions creation.
    log.write_mat(@temp_prefix)
    File.exist?(@temp_prefix + '.mat').should be_true
  end
	
	after(:each) do
    ['.txt', '.csv', '.mat'].each do |ext| 
      File.delete(@temp_prefix + ext) if File.exist?(@temp_prefix + ext)
    end
  end
end