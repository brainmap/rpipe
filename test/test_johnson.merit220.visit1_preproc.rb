require 'helper'
require 'pp'

class TestJohnsonMerit220Preproc < Test::Unit::TestCase
  should "preprocess raw data" do
    pipe = RPipe.new('drivers/mrt00015.yml')
		p = pipe.preproc_jobs.first
		p.preproc_visit
  end
end
