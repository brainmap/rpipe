require 'helper'
require 'pp'

# class TestJohnsonMerit220Preproc < Test::Unit::TestCase
#   should "preprocess raw data" do
#     pipe = RPipe.new('drivers/mrt00015.yml')
#     p = pipe.preproc_jobs.first
#     p.preproc_visit
#   end
# end

# class TestJohnsonMerit220Stats < Test::Unit::TestCase
#   should "run stats on processed data" do
#     pipe = RPipe.new('drivers/mrt00015.yml')
#     s = pipe.stats_jobs.first
#     s.run_first_level_stats
#   end
# end

class TestJohnsonMerit220Integrative < Test::Unit::TestCase
  should "run through a subject." do
    pipe = RPipe.new(File.join(File.dirname(__FILE__), 'drivers', '/mrt00015_hello.yml'))

    # Run Each Job
    pipe.jobs.each do |job|
      job.perform
    end

  end
end

