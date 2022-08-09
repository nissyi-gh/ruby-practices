# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
  end

  def score
    [@first_shot, @second_shot, @third_shot].map(&:score).sum
  end

  def strike?
    @first_shot.mark == 'X'
  end

  def spare?
    !strike? && [@first_shot, @second_shot].map(&:score).sum == 10
  end
end
