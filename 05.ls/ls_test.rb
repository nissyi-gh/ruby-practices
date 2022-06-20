require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_without_option
    assert_equal "ls.rb ls_test.rb", ls
  end
end
