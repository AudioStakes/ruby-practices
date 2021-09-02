# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls/ls'

class LsTest < Minitest::Test # rubocop:disable Metrics/ClassLength
  DIRECTORY_PATH         = File.expand_path('./files/', __dir__)
  FILE_PATH              = File.expand_path('./files/chmod_710.txt', __dir__)
  DEFAULT_TERMINAL_WIDTH = 80

  def test_no_operands
    expected = <<~TEXT
      a\t\t\t\tcreated_5_months_ago
      b\t\t\t\tcreated_7_months_ago
      c\t\t\t\ttmp_dir
      chmod_710.txt\t\t\tあいう
      chmod_742.txt\t\t\tかきく
      chmod_765.txt\t\t\t拡張属性あり.txt
      created_1_month_after\t\t日本語のファイル.txt
    TEXT

    assert_output(expected) do
      Ls::Ls.new([], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH, 'current_directory' => DIRECTORY_PATH }).exec
    end

    # assert_output(`/bin/ls -C`) do
    #   Ls::Ls.new([], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    # end
  end

  def test_one_file_operand
    expected = "/Users/satoudaisuke/src/github.com/AudioStakes/ruby-practices/08.ls_object/test/files/chmod_710.txt\n"

    assert_output(expected) do
      Ls::Ls.new([FILE_PATH], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    end

    # assert_output(`/bin/ls -C #{FILE_PATH}`) do
    #   Ls::Ls.new([FILE_PATH], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    # end
  end

  def test_one_directory_operand
    expected = <<~TEXT
      a\t\t\t\tcreated_5_months_ago
      b\t\t\t\tcreated_7_months_ago
      c\t\t\t\ttmp_dir
      chmod_710.txt\t\t\tあいう
      chmod_742.txt\t\t\tかきく
      chmod_765.txt\t\t\t拡張属性あり.txt
      created_1_month_after\t\t日本語のファイル.txt
    TEXT

    assert_output(expected) do
      Ls::Ls.new([DIRECTORY_PATH], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    end

    # assert_output(`/bin/ls -C #{DIRECTORY_PATH}`) do
    #   Ls::Ls.new([DIRECTORY_PATH], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    # end
  end

  def test_multiple_operands_containing_both_files_and_directories
    expected = <<~TEXT
      /Users/satoudaisuke/src/github.com/AudioStakes/ruby-practices/08.ls_object/test/files/chmod_710.txt

      /Users/satoudaisuke/src/github.com/AudioStakes/ruby-practices/08.ls_object/test/files:
      a\t\t\t\tcreated_5_months_ago
      b\t\t\t\tcreated_7_months_ago
      c\t\t\t\ttmp_dir
      chmod_710.txt\t\t\tあいう
      chmod_742.txt\t\t\tかきく
      chmod_765.txt\t\t\t拡張属性あり.txt
      created_1_month_after\t\t日本語のファイル.txt
    TEXT

    assert_output(expected) do
      Ls::Ls.new([FILE_PATH, DIRECTORY_PATH], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    end

    # assert_output(`/bin/ls -C #{FILE_PATH} #{DIRECTORY_PATH}`) do
    #   Ls::Ls.new([FILE_PATH, DIRECTORY_PATH], { 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    # end
  end

  def test_one_column_output
    expected = <<~TEXT
      a
      b
      c
    TEXT

    assert_output(expected) do
      Ls::Ls.new(%w[a b c], { 'terminal_width' => 8, 'current_directory' => DIRECTORY_PATH }).exec
    end

    # assert_output(`cd #{DIRECTORY_PATH} && COLUMNS=8 /bin/ls -C a b c`) do
    #   Ls::Ls.new(%w[a b c], { 'terminal_width' => 8, 'current_directory' => DIRECTORY_PATH }).exec
    # end
  end

  def test_two_columns_output
    expected = <<~TEXT
      a\tc
      b
    TEXT

    assert_output(expected) do
      Ls::Ls.new(%w[a b c], { 'terminal_width' => 16, 'current_directory' => DIRECTORY_PATH }).exec
    end

    # assert_output(`cd #{DIRECTORY_PATH} && COLUMNS=16 /bin/ls -C a b c`) do
    #   Ls::Ls.new(%w[a b c], { 'terminal_width' => 16, 'current_directory' => DIRECTORY_PATH }).exec
    # end
  end

  def test_three_columns_output
    expected = "a\tb\tc\n"

    assert_output(expected) do
      Ls::Ls.new(%w[a b c], { 'terminal_width' => 24, 'current_directory' => DIRECTORY_PATH }).exec
    end

    # assert_output(`cd #{DIRECTORY_PATH} && COLUMNS=24 /bin/ls -C a b c`) do
    #   Ls::Ls.new(%w[a b c], { 'terminal_width' => 24, 'current_directory' => DIRECTORY_PATH }).exec
    # end
  end

  def test_column_width_is_larger_than_display_width
    expected = "あいう\t\tかきく\n"

    assert_output(expected) do
      Ls::Ls.new(%w[あいう かきく], { 'terminal_width' => 32, 'current_directory' => DIRECTORY_PATH }).exec
    end

    # assert_output(`cd #{DIRECTORY_PATH} && COLUMNS=32 /bin/ls -C あいう かきく`) do
    #   Ls::Ls.new(%w[あいう かきく], { 'terminal_width' => 32, 'current_directory' => DIRECTORY_PATH }).exec
    # end
  end

  def test_option_a
    expected = <<~TEXT
      .\t\t\t\tcreated_1_month_after
      ..\t\t\t\tcreated_5_months_ago
      .dotfile\t\t\tcreated_7_months_ago
      a\t\t\t\ttmp_dir
      b\t\t\t\tあいう
      c\t\t\t\tかきく
      chmod_710.txt\t\t\t拡張属性あり.txt
      chmod_742.txt\t\t\t日本語のファイル.txt
      chmod_765.txt
    TEXT

    assert_output(expected) do
      Ls::Ls.new([DIRECTORY_PATH], { 'a' => true, 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    end

    # assert_output(`/bin/ls -a -C #{DIRECTORY_PATH}`) do
    #   Ls::Ls.new([DIRECTORY_PATH], { 'a' => true, 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    # end
  end

  def test_option_r
    expected = <<~TEXT
      日本語のファイル.txt\t\tcreated_1_month_after
      拡張属性あり.txt\t\tchmod_765.txt
      かきく\t\t\t\tchmod_742.txt
      あいう\t\t\t\tchmod_710.txt
      tmp_dir\t\t\t\tc
      created_7_months_ago\t\tb
      created_5_months_ago\t\ta
    TEXT

    assert_output(expected) do
      Ls::Ls.new([DIRECTORY_PATH], { 'r' => true, 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    end

    # assert_output(`/bin/ls -r -C #{DIRECTORY_PATH}`) do
    #   Ls::Ls.new([DIRECTORY_PATH], { 'r' => true, 'terminal_width' => DEFAULT_TERMINAL_WIDTH }).exec
    # end
  end

  def test_option_l
    # expected = <<~TEXT
    #   total 8
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 a
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 b
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 c
    #   -rwxr-xr-x  1 satoudaisuke  staff    0 Sep 13 13:23 chmod_710.txt
    #   -rwxr-xr-x  1 satoudaisuke  staff    0 Sep 13 13:23 chmod_742.txt
    #   -rwxr-xr-x  1 satoudaisuke  staff    0 Sep 13 13:23 chmod_765.txt
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 created_1_month_after
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 created_5_months_ago
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 created_7_months_ago
    #   drwxr-xr-x  5 satoudaisuke  staff  160 Sep 13 13:23 tmp_dir
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 あいう
    #   -rw-r--r--  1 satoudaisuke  staff    0 Sep 13 13:23 かきく
    #   -rw-r--r--@ 1 satoudaisuke  staff    0 Sep 13 13:23 拡張属性あり.txt
    #   -rw-r--r--  1 satoudaisuke  staff   13 Sep 13 13:23 日本語のファイル.txt
    # TEXT

    # assert_output(expected) do
    #   Ls::Ls.new([DIRECTORY_PATH], { 'l' => true }).exec
    # end

    assert_output(`/bin/ls -l #{DIRECTORY_PATH}`) do
      Ls::Ls.new([DIRECTORY_PATH], { 'l' => true }).exec
    end
  end

  def test_option_arl
    # expected = <<~TEXT
    #   total 8
    #   -rw-r--r--   1 satoudaisuke  staff   13 Sep 13 13:23 日本語のファイル.txt
    #   -rw-r--r--@  1 satoudaisuke  staff    0 Sep 13 13:23 拡張属性あり.txt
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 かきく
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 あいう
    #   drwxr-xr-x   5 satoudaisuke  staff  160 Sep 13 13:23 tmp_dir
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 created_7_months_ago
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 created_5_months_ago
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 created_1_month_after
    #   -rwxr-xr-x   1 satoudaisuke  staff    0 Sep 13 13:23 chmod_765.txt
    #   -rwxr-xr-x   1 satoudaisuke  staff    0 Sep 13 13:23 chmod_742.txt
    #   -rwxr-xr-x   1 satoudaisuke  staff    0 Sep 13 13:23 chmod_710.txt
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 c
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 b
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 a
    #   -rw-r--r--   1 satoudaisuke  staff    0 Sep 13 13:23 .dotfile
    #   drwxr-xr-x   4 satoudaisuke  staff  128 Sep 13 13:23 ..
    #   drwxr-xr-x  17 satoudaisuke  staff  544 Sep 13 13:23 .
    # TEXT

    # assert_output(expected) do
    #   Ls::Ls.new([DIRECTORY_PATH], { 'a' => true, 'r' => true, 'l' => true }).exec
    # end

    assert_output(`/bin/ls -arl #{DIRECTORY_PATH}`) do
      Ls::Ls.new([DIRECTORY_PATH], { 'a' => true, 'r' => true, 'l' => true }).exec
    end
  end
end
