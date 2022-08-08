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
end
