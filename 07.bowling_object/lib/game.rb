# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  def initialize(input)
    @frames = build_frames(input)
  end

  def score
    @frames.sum(&:score)
  end

  private

  def build_frames(input)
    shots  = input.split(',').map { |mark| Shot.new(mark) }
    frames = Array.new(10) { Frame.new }

    frames.each_with_index do |frame, i|
      if i < 9
        frame.shots = shots.shift(shots[0].strike? ? 1 : 2)
        frame.bonus = calc_bonus(frame, shots[..1])
      else
        frame.shots = shots  # 残りは全て10フレーム目の shots
      end
    end

    frames
  end

  def calc_bonus(frame, next_two_shots)
    if frame.strike?
      next_two_shots.sum(&:score)
    elsif frame.spare?
      next_two_shots[0].score
    else
      0
    end
  end
end
