# frozen_string_literal: true

require_relative './shot'

class Frame
  attr_writer :bonus

  def initialize(marks)
    @shots = marks.map { |mark| Shot.new(mark) }
    @bonus = 0
  end

  def score
    @shots.sum(&:score) + @bonus
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @shots.sum(&:score) == 10
  end
end
