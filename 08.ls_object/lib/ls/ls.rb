# frozen_string_literal: true

require_relative './long_format_information'
require_relative './multi_column_format'

module Ls
  class Ls
    def initialize(operands = [], options = {})
      Dir.chdir(options['current_directory']) if options['current_directory']

      @file_paths           = operands.select { |operand| FileTest.file?(operand) }
      @directory_paths      = operands.empty? ? [Dir.pwd] : operands.select { |operand| FileTest.directory?(operand) }
      @is_multiple_operands = operands.size > 1
      @options              = options
    end

    def exec
      output = []

      output << generate_files_output_from(@file_paths)            unless @file_paths.empty?
      output << generate_directories_output_from(@directory_paths) unless @directory_paths.empty?

      puts output
    end

    private

    def generate_files_output_from(file_names, directory_path = nil)
      file_names = sort(file_names, reverse: @options['r'])

      output = []

      if @options['l']
        long_format_informations = file_names.map { |file_name| LongFormatInformation.create(file_name, directory_path) }

        output << "total #{long_format_informations.sum(&:blocks)}" if directory_path
        output << LongFormatInformation.generate_long_format_output_from(long_format_informations)
      else
        terminal_width = @options['terminal_width'] || `tput cols`.delete('^0-9').to_i

        output << MultiColumnFormat.generate_multi_column_output_from(file_names, terminal_width)
      end

      output
    end

    def generate_directories_output_from(directory_paths)
      directory_paths = sort(directory_paths, reverse: @options['r'])

      output = []

      directory_paths.each do |directory_path|
        output << "\n#{directory_path}:" if @is_multiple_operands

        file_names = Dir.glob('*', @options['a'] ? File::FNM_DOTMATCH : 0, base: directory_path)

        output << generate_files_output_from(file_names, directory_path) unless file_names.empty?
      end

      output
    end

    def sort(names, reverse:)
      reverse ? names.sort.reverse : names.sort
    end
  end
end
