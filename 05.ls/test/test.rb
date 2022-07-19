require 'minitest/unit'
require 'minitest/autorun'
require_relative '../ls'

class TestLs < MiniTest::Unit::TestCase
  def test_main
    assert_equal 'main', Ls.main
  end
end
