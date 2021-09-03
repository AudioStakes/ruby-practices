# frozen_string_literal: true

require 'date'
require 'etc'

module Ls
  class LongFormatInformation
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

    class << self
      def create(name, directory_path)
        file_path              = directory_path ? "#{directory_path}/#{name}" : name
        has_extended_attribute = !`xattr #{file_path}`.empty?

        new(name, File.lstat(file_path), has_extended_attribute)
      end

      def generate_long_format_output_from(long_format_informations)
        array_of_informations = long_format_informations.map(&:informations)
        max_lengths           = array_of_informations.transpose[1..5].map { |informations| informations.map(&:to_s).map(&:length).max }
        template              = "%s %#{max_lengths[0]}s %#{max_lengths[1]}s  %#{max_lengths[2]}s  %#{max_lengths[3]}s %#{max_lengths[4]}s %s"

        array_of_informations.map { |informations| format(template % informations) }
      end
    end

    def initialize(name, lstat, has_extended_attribute)
      @name                   = name
      @lstat                  = lstat
      @has_extended_attribute = has_extended_attribute
    end

    def blocks
      @lstat.blocks
    end

    def informations
      [file_mode, nlink, user_name, group_name, size, formatted_mtime, @name]
    end

    private

    def file_mode
      [char_file_type, symbolic_permissions, extended_attribute_sign].join
    end

    def char_file_type
      STRING_TO_CHAR_FILE_TYPE[@lstat.ftype]
    end

    def symbolic_permissions
      numeric_permissions = @lstat.mode.to_s(8)[-3..]

      numeric_permissions.gsub(/\d/, NUMERIC_TO_SYMBOLIC_PERMISSION)
    end

    def extended_attribute_sign
      @has_extended_attribute ? '@' : ' '
    end

    def nlink
      @lstat.nlink
    end

    def user_name
      Etc.getpwuid(@lstat.uid).name
    end

    def group_name
      Etc.getgrgid(@lstat.gid).name
    end

    def size
      @lstat.size
    end

    def formatted_mtime
      mtime = @lstat.mtime

      if DateTime.now.prev_month(6).to_time < mtime && mtime < Time.now
        mtime.strftime('%-b %_d %H:%M')
      else
        mtime.strftime('%-b %_d  %Y')
      end
    end
  end
end
