# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class TestShot < MiniTest::Test
  def test_has_expect_score
    assert_equal 5, Shot.new(5).score
  end

  def test_has_expect_mark_when_strike
    assert_equal 'X', Shot.new('X').mark
  end
end
