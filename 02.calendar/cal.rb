#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

options            = ARGV.getopts('m:y:')
year               = options['y']&.to_i || Date.today.year
month              = options['m']&.to_i || Date.today.month
beginning_of_month = Date.new(year, month, 1)
end_of_month       = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(20)
puts '日 月 火 水 木 金 土'

# 第1週を右側に詰めて表示するため、月初の曜日に合わせて空白を出力
beginning_of_month.wday.times { print '   ' }

(beginning_of_month..end_of_month).each do |date|
  print date.day.to_s.rjust(2) + ' ' # rubocop:disable Style/StringConcatenation
  puts if date.saturday? || date == end_of_month
end
