# frozen_string_literal: true

class Frame
  attr_writer :shots, :bonus

  def initialize
    @shots = []
    @bonus = 0
  end

  def score
    @shots.sum(&:score) + @bonus
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && @shots.sum(&:score) == 10
  end
end
