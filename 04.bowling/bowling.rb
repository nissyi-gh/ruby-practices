# frozen_string_literal: true

def replace_strike_to_score_and_convert_integer(score)
  shots = []

  score.each do |s|
    if s == 'X'
      if shots.size % 2 == 0
        shots << 10
        shots << 0
      else
        shots << 10
      end
    else
      shots << s.to_i
    end
  end

  shots
end

def slice_each_frame(shots)
  frames = []

  shots.each_slice(2) do |s|
    s.pop if s[0] == 10 && s[1].zero?
    frames << s
  end

  until frames.size == 10
    frames[9].concat(frames[10])
    frames.delete_at(10)
  end

  frames
end

def calculate_total_score(frames)
  total = 0

  frames.each_with_index do |f, index|
    if index <= 8
      total += calculate_each_frame_score(f, index, frames)
    else
      total += f.sum
    end
  end

  total
end

def calculate_each_frame_score(frame, index, frames)
  frame_score = frame.sum

  if frame[0] == 10
    frame_score += frames[index + 1][0]

    if frames[index + 1][0] == 10
      if index == 8
        frame_score += frames[index + 1][1]
      else
        frame_score += frames[index + 2][0]
      end
    else
      frame_score += frames[index + 1][1]
    end
  elsif frame.sum == 10
    frame_score += frames[index + 1][0]
  end

  frame_score
end

score = ARGV[0].split(",")

shots = replace_strike_to_score_and_convert_integer(score)
frames = slice_each_frame(shots)
p calculate_total_score(frames)
