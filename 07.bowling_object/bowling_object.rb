#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/game'

puts Game.new(ARGV[0]).score
