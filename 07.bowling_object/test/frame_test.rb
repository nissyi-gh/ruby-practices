# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/frame'

class TestFrame < MiniTest::Test
  def test_instance_needs_at_least_1_score
    assert_raises { Frame.new }
  end

  def test_first_shot_score
    assert_equal 0, Frame.new(0, 10).first_shot.score
  end

  def test_second_shot_score
    assert_equal 10, Frame.new(0, 10).second_shot.score
  end

  def test_third_shot_score
    assert_equal 10, Frame.new(5, 5, 10).third_shot.score
  end

  def test_score_when_1_time_throw
    assert_equal 10, Frame.new(10).score
  end

  def test_score_when_2_times_throw
    assert_equal 0, Frame.new(0, 0).score
  end

  def test_score_when_3_times_throw
    assert_equal 18, Frame.new(5, 5, 8).score
  end

  def test_strike
    assert Frame.new('X').strike?
  end

  def test_not_strike_when_spare
    refute Frame.new(0, 'X').strike?
  end

  def test_spare
    assert Frame.new(3, 7).spare?
  end

  def test_not_spare
    refute Frame.new('X').spare?
  end
end
