require 'helper'
require 'pp'

class TestDynamicMethodInclusion < Test::Unit::TestCase
  should "include a dynamic method for recon" do
    pipe = RPipe.new('drivers/mrt00015_hello.yml')
		r = pipe.recon_jobs.first
		assert_equal "=== Hello World! ===", r.hello
  end
end
