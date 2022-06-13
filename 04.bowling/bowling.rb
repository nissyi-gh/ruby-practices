# frozen_string_literal: true

def main
  scores = ARGV[0].split(',')

  shots = replace_strike_to_score_and_convert_integer(scores)
  frames = slice_each_frame(shots)
  p calculate_total_score(frames)
end

def replace_strike_to_score_and_convert_integer(scores)
  shots = []

  scores.each do |score|
    if score == 'X'
      shots << 10
      shots << 0 if shots.size.odd?
    else
      shots << score.to_i
    end
  end

  shots
end

def slice_each_frame(shots)
  frames = []

  shots.each_slice(2) do |shot|
    shot.pop if shot[0] == 10 && shot[1].zero?
    frames << shot
  end

  until frames.size == 10
    frames[9].concat(frames[10])
    frames.delete_at(10)
  end

  frames
end

def calculate_total_score(frames)
  total = 0

  frames.each_with_index do |frame, index|
    total += index <= 8 ? calculate_each_frame_score(frame, index, frames) : frame.sum
  end

  total
end

def calculate_each_frame_score(frame, index, frames)
  frame_score = frame.sum

  if frame[0] == 10
    frame_score += frames[index + 1][0]

    return frame_score += frames[index + 1][1] if frames[index + 1][0] < 10

    frame_score += index == 8 ? frames[index + 1][1] : frames[index + 2][0]
  elsif frame.sum == 10
    frame_score += frames[index + 1][0]
  end

  frame_score
end

main
