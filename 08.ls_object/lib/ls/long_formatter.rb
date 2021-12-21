# frozen_string_literal: true

module Ls
  module LongFormatter
    class << self
      def format(block)
        output = []

        output << "total #{block.files.sum(&:blocks)}" if block.directory_path
        output << format_files(block.files)

        output
      end

      private

      def format_files(files)
        long_informations = files.map { |file| long_format_information_of(file) }
        max_lengths       = long_informations.transpose[1..5].map { |same_field_values| same_field_values.map(&:to_s).map(&:length).max }
        template          = "%s %#{max_lengths[0]}s %#{max_lengths[1]}s  %#{max_lengths[2]}s  %#{max_lengths[3]}s %#{max_lengths[4]}s %s"

        long_informations.map { |informations| Kernel.format(template % informations) }
      end

      def long_format_information_of(file)
        [file.file_mode, file.nlink, file.user_name, file.group_name, file.size, file.formatted_mtime, file.name]
      end
    end
  end
end
