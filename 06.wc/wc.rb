#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  inputs  = prepare_inputs(ARGV)

  output_rows = inputs.map { |text, name| count_lines_words_bytes_of(text, name, options['l']) }
  output_rows << total_of(output_rows) if output_rows.size > 1

  puts(output_rows.map { |row| format_row(row) })
end

def prepare_inputs(args)
  if args.empty?
    [[$stdin.read, nil]]
  else
    args.map { |file_name| [File.read(file_name), file_name] }
  end
end

def count_lines_words_bytes_of(text, name, is_lines_only)
  [].tap do |row|
    row << text.count("\n")
    row << text.split(' ').size unless is_lines_only
    row << text.bytesize        unless is_lines_only
    row << name                 if name
  end
end

def total_of(rows)
  lines, words, bytes = rows.transpose[..-2].map(&:sum)

  [].tap do |total_row|
    total_row << lines
    total_row << words if words
    total_row << bytes if bytes
    total_row << 'total'
  end
end

def format_row(row)
  row.map { |e| format(e.is_a?(Integer) ? '%8d' : ' %s', e) }.join
end

main
