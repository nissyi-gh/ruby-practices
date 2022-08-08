# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = second_shot ? Shot.new(second_shot) : nil
    @third_shot = third_shot ? Shot.new(third_shot) : nil
  end

  def score
    [@first_shot, @second_shot, @third_shot].compact.map(&:score).sum
  end
end
