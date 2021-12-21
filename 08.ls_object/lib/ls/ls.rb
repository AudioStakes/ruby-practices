# frozen_string_literal: true

require_relative './block'
require_relative './long_formatter'
require_relative './multi_column_formatter'

module Ls
  class Ls
    def initialize(operands, options)
      operands = [Dir.pwd] if operands.empty?
      MultiColumnFormatter.terminal_width = options['terminal_width'] if options['terminal_width'] # テスト用にターミナル幅を指定できるようにした

      @is_multiple_operands = operands.size > 1
      @formatter            = options['l'] ? LongFormatter : MultiColumnFormatter
      @blocks               = build_blocks(operands, options)
    end

    def exec
      @blocks.each do |block|
        puts "\n#{block.directory_path}:" if block.directory_path && @is_multiple_operands

        puts @formatter.format(block)
      end
    end

    private

    def build_blocks(operands, options)
      file_paths, directory_paths = operands.partition { |operand| FileTest.file?(operand) }

      blocks = []

      unless file_paths.empty?
        sort!(file_paths, reverse: options['r'])

        blocks << Block.new(file_paths)
      end

      unless directory_paths.empty?
        sort!(directory_paths, reverse: options['r'])

        directory_paths.map do |directory_path|
          file_names = Dir.glob('*', options['a'] ? ::File::FNM_DOTMATCH : 0, base: directory_path)

          sort!(file_names, reverse: options['r'])

          blocks << Block.new(file_names, directory_path)
        end
      end

      blocks
    end

    def sort!(names, reverse:)
      reverse ? names.sort!.reverse! : names.sort!
    end
  end
end
