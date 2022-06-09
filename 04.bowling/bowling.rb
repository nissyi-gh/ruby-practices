# frozen_string_literal: true

def replace_strike_to_score_and_convert_integer(score)
  shots = []

  score.each do |s|
    if s == 'X'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  end

  shots
end

def slice_each_frame(shots)
  frames = []

  shots.each_slice(2) do |s|
    frames << s
  end

  if frames[10]
    frames[9].concat(frames[10])
    frames.pop
  end

  frames
end

score = ARGV[0].split(",")
shots = []
frames = []

shots = replace_strike_to_score_and_convert_integer(score)
frames = slice_each_frame(shots)
