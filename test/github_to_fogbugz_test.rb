require 'test_helper'

class GithubToFogbugzTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GithubToFogbugz::VERSION
  end
end
