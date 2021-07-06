#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'etc'
require 'optparse'

STRING_TO_CHAR_FILE_TYPE = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's',
  'unknown' => 'u'
}.freeze

NUMERIC_TO_SYMBOLIC_PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = ARGV.getopts('alr')

  file_names = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  file_names = file_names.sort
  file_names = file_names.reverse if options['r']

  puts options['l'] ? files_in_long_format(file_names) : files(file_names)
end

def files_in_long_format(file_names)
  files_in_long_format = []
  file_lstats          = file_names.map { |file_name| File.lstat(file_name) }

  files_in_long_format << "total #{file_lstats.map(&:blocks).sum}"
  files_in_long_format << file_names.zip(file_lstats).map do |file_name, file_lstat|
    char_file_type       = STRING_TO_CHAR_FILE_TYPE[file_lstat.ftype]
    symbolic_permissions = symbolic_permissions(file_lstat.mode)
    nlink                = file_lstat.nlink
    user_name            = Etc.getpwuid(file_lstat.uid).name
    group_name           = Etc.getgrgid(file_lstat.gid).name
    size                 = file_lstat.size
    formatted_mtime      = formatted_time(file_lstat.mtime)

    "#{char_file_type}#{symbolic_permissions} #{nlink} #{user_name} #{group_name} #{size} #{formatted_mtime} #{file_name}"
  end
end

def symbolic_permissions(mode)
  numeric_permissions = mode.to_s(8)[-3..]

  numeric_permissions.gsub(/\d/, NUMERIC_TO_SYMBOLIC_PERMISSION)
end

def formatted_time(time)
  if DateTime.now.prev_month(6).to_time < time && time < Time.now
    time.strftime('%-m %-d %H:%M')
  else
    time.strftime('%-m %-d  %Y')
  end
end

def files(file_names)
  max_name_length = file_names.map(&:length).max
  file_names      = file_names.map { |name| name.ljust(max_name_length) }

  split_into_groups(file_names, 3).transpose.map { |line| line.join(' ') }
end

def split_into_groups(array, number_of_groups)
  size_of_group = array.size / number_of_groups
  size_of_group += 1 unless (array.size % number_of_groups).zero?

  array.each_slice(size_of_group).to_a.each do |group|
    (size_of_group - group.size).times { group << nil }
  end
end

main
