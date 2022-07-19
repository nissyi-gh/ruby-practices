require 'minitest/autorun'
require_relative '../ls'
require_relative './helpers'

class TestLs < MiniTest::Test
  include TestHelpers

  def setup
    ARGV.clear
  end

  def test_main
    assert_equal 'main', Ls.main
  end

  def test_a_option_is_set?
    set_a_option
    assert_equal ['-a'], ARGV
  end

  def test_l_option_is_set?
    set_l_option
    assert_equal ['-l'], ARGV
  end

  def test_r_option_is_set?
    set_r_option
    assert_equal ['-r'], ARGV
  end
end
