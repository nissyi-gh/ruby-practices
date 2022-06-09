# frozen_string_literal: true
score = ARGV[0].split(",")
shots = []

score.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end
