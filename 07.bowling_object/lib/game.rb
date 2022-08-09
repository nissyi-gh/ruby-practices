# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize
    @frames =
      Game.parse_marks.map do |frame_scores|
        Frame.new(frame_scores[0], frame_scores[1], frame_scores[2])
      end
  end

  def self.parse_marks
    game_scores = []
    marks = ARGV[0].split(',')

    9.times do
      frame_scores = marks.shift(2)

      if frame_scores[0] == 'X'
        game_scores << ['X']
        marks.unshift(frame_scores[1])
      else
        game_scores << frame_scores
      end
    end

    game_scores << marks
  end

  def score
    score = 0
    @frames << nil

    @frames.each_cons(3) do |current_frame, next_frame, subsequent_frame|
      score += current_frame.score

      score +=
        if current_frame.strike?
          if next_frame.strike? && subsequent_frame
            next_frame.first_shot.score + subsequent_frame.first_shot.score
          else
            # next_frame.scoreだと3投目を含んでしまう
            next_frame.first_shot.score + next_frame.second_shot.score
          end
        elsif current_frame.spare?
          next_frame.first_shot.score
        else
          0
        end
    end

    @frames.pop
    score += @frames.last.score
  end
end
