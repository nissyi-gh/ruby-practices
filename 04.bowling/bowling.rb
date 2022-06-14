# frozen_string_literal: true

def main
  scores = ARGV[0].split(',')

  shots = replace_strike_to_score(scores)
  frames = slice_each_frame(shots)
  p calculate_total_score(frames)
end

def replace_strike_to_score(scores)
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

  # 次のフレームや、その次のフレームを参照しやすくするためにeachではなくuntil emptyで回しています
  until frames.empty?
    frame = frames.shift
    total += frames.size.zero? ? frame.sum : calculate_each_frame(frame, frames)
  end

  total
end

def calculate_each_frame(frame, frames)
  frame_score = frame.sum
  next_frame = frames[0]
  after_next_frame = frames[1]

  if frame[0] == 10
    frame_score += next_frame[0]

    return frame_score += next_frame[1] if next_frame[0] < 10

    frame_score += after_next_frame.nil? ? next_frame[1] : after_next_frame[0]
  elsif frame.sum == 10
    frame_score += next_frame[0]
  end

  frame_score
end

main
