#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './lib/ls/ls'

def main
  options = ARGV.getopts('alr')

  Ls::Ls.new(ARGV, options).exec
end

main
