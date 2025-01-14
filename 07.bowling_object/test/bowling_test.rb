# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class BowlingTest < Minitest::Test
  def test_spare_in_final_frame
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'

    assert_equal 139, Game.new(input).score
  end

  def test_strike_in_final_frame
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'

    assert_equal 134, Game.new(input).score
  end

  def test_turkey_in_final_frame
    input = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'

    assert_equal 164, Game.new(input).score
  end

  def test_turkey_out_of_final_frame
    input = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'

    assert_equal 107, Game.new(input).score
  end

  def test_perfect_game
    input = 'X,X,X,X,X,X,X,X,X,X,X,X'

    assert_equal 300, Game.new(input).score
  end
end
