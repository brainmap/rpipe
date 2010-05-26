require 'spec_helper'
require 'pp'

describe "Integration Processing for Johnson.Merit220" do
  before(:all) do
    @driver_file = File.join(File.dirname(__FILE__), 'drivers/mrt00015.yml')
  end

  it "should preprocess raw data" do
    pipe = RPipe.new(@driver_file)
    p = pipe.preproc_jobs.first
    p.preproc_visit
  end
  
  it "should run stats on processed data" do
    pipe = RPipe.new(@driver_file)
    s = pipe.stats_jobs.first
    s.run_first_level_stats
  end
  
  it "should run all jobs for test subject." do
    pipe = RPipe.new(@driver_file)
    # Run Each Job
    pipe.jobs.each do |job|
      job.perform
    end
  end
end

