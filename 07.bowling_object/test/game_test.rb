# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class TestGame < MiniTest::Test
  def setup
    ARGV.clear
  end

  def test_parse_marks_example_a
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    frame_scores = Game.parse_marks

    assert_equal %w[6 3], frame_scores[0]
    assert_equal %w[9 0], frame_scores[1]
    assert_equal %w[0 3], frame_scores[2]
    assert_equal %w[8 2], frame_scores[3]
    assert_equal %w[7 3], frame_scores[4]
    assert_equal %w[X], frame_scores[5]
    assert_equal %w[9 1], frame_scores[6]
    assert_equal %w[8 0], frame_scores[7]
    assert_equal %w[X], frame_scores[8]
    assert_equal %w[6 4 5], frame_scores[9]
  end

  # ~9フレーム目まではexample_aと同じ
  def test_parse_marks_example_b
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'

    assert_equal %w[X X X], Game.parse_marks[9]
  end

  def test_parse_marks_example_c
    ARGV << '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    frame_scores = Game.parse_marks

    assert_equal %w[0 10], frame_scores[0]
    assert_equal %w[1 5], frame_scores[1]
    assert_equal %w[0 0], frame_scores[2]
    assert_equal %w[0 0], frame_scores[3]
    assert_equal %w[X], frame_scores[4]
    assert_equal %w[X], frame_scores[5]
    assert_equal %w[X], frame_scores[6]
    assert_equal %w[5 1], frame_scores[7]
    assert_equal %w[8 1], frame_scores[8]
    assert_equal %w[0 4], frame_scores[9]
  end

  # ~8フレーム目まではexample_aと同じ
  def test_parse_marks_example_d
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    frame_scores = Game.parse_marks

    assert_equal %w[X], frame_scores[8]
    assert_equal %w[X 0 0], frame_scores[9]
  end

  def test_parse_marks_perfect_game
    ARGV << 'X,X,X,X,X,X,X,X,X,X,X,X'

    (0..8).each { |n| assert_equal %w[X], Game.parse_marks[n] }
    assert_equal %w[X X X], Game.parse_marks[9]
  end

  def test_score_example_a
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    assert_equal 139, Game.new.score
  end

  def test_score_example_b
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    assert_equal 164, Game.new.score
  end

  def test_score_example_c
    ARGV << '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal 107, Game.new.score
  end

  def test_score_example_d
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    assert_equal 134, Game.new.score
  end

  def test_score_example_e
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    assert_equal 144, Game.new.score
  end

  def test_score_perfect_game
    ARGV << 'X,X,X,X,X,X,X,X,X,X,X,X'
    assert_equal 300, Game.new.score
  end
end
