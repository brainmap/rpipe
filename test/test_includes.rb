require 'helper'

class TestIncludes < Test::Unit::TestCase
  should "include the standard implementation of reconstruction" do
		r = Reconstruction.new(
			{ 'subid' => 'swallow001', 'rawdir' => nil, 'origdir' => nil, 'procdir' => nil },
			{ 'scans' => nil, 'source' => nil, 'method' => nil }
		)
		assert_equal "swallow001", r.subid
  end
end
