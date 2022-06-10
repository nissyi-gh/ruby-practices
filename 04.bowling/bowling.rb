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

def ignore_zero_after_strike_until_9_frame(shots)
  pure_shots = []

  0.step(8) do |n|
    frame = n * 2

    if shots[frame] == 10
      pure_shots << shots[frame]
    else
      pure_shots << shots[frame]
      pure_shots << shots[frame + 1]
    end
  end

  pure_shots
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

def calculate_total_score(frames)
  total = 0

  frames.each_with_index do |f, index|
    if index <= 8
      total += calculate_each_frame_score(f, frames[index + 1])
    else
      total += f.sum
    end
  end

  total
end

def calculate_each_frame_score(frame, next_frame)
  0
end

score = ARGV[0].split(",")
shots = []
frames = []

shots = replace_strike_to_score_and_convert_integer(score)
pure_shots_until_9_frame = ignore_zero_after_strike(shots)
frames = slice_each_frame(shots)
p calculate_total_score(frames)
