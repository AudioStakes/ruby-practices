# frozen_string_literal: true

require 'date'
require 'etc'

module Ls
  class File
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

    attr_reader :name

    def initialize(name, directory_path)
      @name = name
      @directory_path = directory_path
      @lstat = ::File.lstat(path)
    end

    def blocks
      @lstat.blocks
    end

    def file_mode
      [char_file_type, symbolic_permissions, extended_attribute_sign].join
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

    private

    def path
      @directory_path ? "#{@directory_path}/#{@name}" : @name
    end

    def char_file_type
      STRING_TO_CHAR_FILE_TYPE[@lstat.ftype]
    end

    def symbolic_permissions
      numeric_permissions = @lstat.mode.to_s(8)[-3..]

      numeric_permissions.gsub(/\d/, NUMERIC_TO_SYMBOLIC_PERMISSION)
    end

    def extended_attribute_sign
      `xattr #{path}`.empty? ? ' ' : '@'
    end
  end
end
