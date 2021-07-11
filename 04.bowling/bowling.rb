#!/usr/bin/env ruby
# frozen_string_literal: true

# 数値に変換
scores = ARGV[0].split(',').map do |score|
  score == 'X' ? 10 : score.to_i
end

# フレームを作成
frames = []
frame = []
scores.each do |score|
  if frames.size < 9 # 9フレーム目まで
    frame << score

    if frame[0] == 10 || frame.size == 2 # ストライクもしくは2投目
      frames << frame.dup
      frame.clear
    end
  else
    frames[9] ||= []
    frames[9] << score
  end
end

# 得点を計算
point = 0
frames.each_with_index do |current_frame, i|
  point += current_frame.sum

  # ストライク・スペアによる得点の加算
  if i < 9 # 9フレーム目まで
    if current_frame[0] == 10 # ストライク
      point += frames[i + 1][0]
      point += frames[i + 1][1] || frames[i + 2][0]
    elsif current_frame.sum == 10 # スペア
      point += frames[i + 1][0]
    end
  end
end

puts point
