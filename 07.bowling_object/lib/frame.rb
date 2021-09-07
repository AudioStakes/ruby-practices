# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_reader :shots

  def initialize(marks)
    @shots = marks.map { |mark| Shot.new(mark) }
    @bonus = 0
  end

  def set_bonus(next_frame, next_next_frame)
    bonus = 0

    if strike?
      bonus += next_frame.shots[0].score
      bonus += next_frame.shots[1]&.score || next_next_frame.shots[0].score
    elsif spare?
      bonus += next_frame.shots[0].score
    end

    @bonus = bonus
  end

  def score
    @shots.sum(&:score) + @bonus
  end

  private

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @shots.sum(&:score) == 10
  end
end
