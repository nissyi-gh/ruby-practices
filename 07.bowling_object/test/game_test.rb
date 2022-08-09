# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class TestGame < MiniTest::Test
  def setup
    ARGV.clear
  end

  def test_parse_scores_pattern_a
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    game = Game.new
    assert_equal 9, game.frames[0].score
    assert_equal 9, game.frames[1].score
    assert_equal 3, game.frames[2].score
    assert_equal 10, game.frames[3].score
    assert_equal 10, game.frames[4].score
    assert_equal 10, game.frames[5].score
    assert_equal 10, game.frames[6].score
    assert_equal 8, game.frames[7].score
    assert_equal 10, game.frames[8].score
    assert_equal 15, game.frames[9].score
  end

  # ~9フレーム目まではパターンaと同じ
  def test_parse_scores_pattern_b
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    game = Game.new
    assert_equal 30, game.frames[9].score
  end

  def test_parse_scores_pattern_c
    ARGV << '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    game = Game.new
    assert_equal 10, game.frames[0].score
    assert_equal 6, game.frames[1].score
    assert_equal 0, game.frames[2].score
    assert_equal 0, game.frames[3].score
    assert_equal 10, game.frames[4].score
    assert_equal 10, game.frames[5].score
    assert_equal 10, game.frames[6].score
    assert_equal 6, game.frames[7].score
    assert_equal 9, game.frames[8].score
    assert_equal 4, game.frames[9].score
  end

  def test_parse_scores_pattern_d
    ARGV << '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    game = Game.new
    assert_equal 9, game.frames[0].score
    assert_equal 9, game.frames[1].score
    assert_equal 3, game.frames[2].score
    assert_equal 10, game.frames[3].score
    assert_equal 10, game.frames[4].score
    assert_equal 10, game.frames[5].score
    assert_equal 10, game.frames[6].score
    assert_equal 8, game.frames[7].score
    assert_equal 10, game.frames[8].score
    assert_equal 10, game.frames[9].score
  end

  def test_parse_scores_pattern_e
    ARGV << 'X,X,X,X,X,X,X,X,X,X,X,X'
    game = Game.new
    (0..8).each do |n|
      assert_equal 10, game.frames[n].score
    end
    assert_equal 30, game.frames[9].score
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
