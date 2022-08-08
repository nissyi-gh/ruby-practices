# frozen_string_literal: true

class Shot
  attr_reader :mark, :score

  def initialize(mark)
    @mark = mark
    @score = mark
  end
end
