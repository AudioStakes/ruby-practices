# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(input)
    @frames = build_frames(input)
  end

  def score
    @frames.sum(&:score)
  end

  private

  def build_frames(input)
    marks  = input.split(',')
    frames = []

    9.times do
      frame = Frame.new(marks.shift(marks[0] == 'X' ? 1 : 2))
      frame.bonus = calc_bonus(frame, marks[..1])

      frames << frame
    end

    frames << Frame.new(marks)  # 残りは全て10フレーム目の shots

    frames
  end

  def calc_bonus(frame, next_two_marks)
    next_two_scores = next_two_marks.map{ |mark| mark == 'X' ? 10 : mark.to_i }

    if frame.strike?
      next_two_scores.sum
    elsif frame.spare?
      next_two_scores[0]
    else
      0
    end
  end
end
