require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_without_option
    assert_equal ".gitkeep\nt.txt\nls.rb", ls
  end
end
