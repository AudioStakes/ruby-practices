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

    9.times { frames << Frame.new(marks.shift(marks[0] == 'X' ? 1 : 2)) }
    frames << Frame.new(marks) # 残りは全て10フレーム目の marks

    [*frames, nil].each_cons(3) { |frame, next_frame, next_next_frame| frame.set_bonus(next_frame, next_next_frame) }

    frames
  end
end
