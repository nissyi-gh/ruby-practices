# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../frame'

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
end
