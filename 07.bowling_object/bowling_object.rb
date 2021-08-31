#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/game'

p Game.new(ARGV[0]).score
