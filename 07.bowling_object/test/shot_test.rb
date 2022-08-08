# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class TestShot < MiniTest::Test
  def test_has_expect_mark_when_strike
    assert_equal 'X', Shot.new('X').mark
  end

  def test_score_when_strike
    assert_equal 10, Shot.new('X').score
  end
end
