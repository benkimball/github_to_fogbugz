require 'test_helper'

class GhIssueTest < MiniTest::Test
  def test_that_it_exists
    ::GithubToFogbugz::GhIssue.new(nil)
  end
end
