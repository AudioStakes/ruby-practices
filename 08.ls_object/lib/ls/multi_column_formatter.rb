# frozen_string_literal: true

module Ls
  module MultiColumnFormatter
    TAB_WIDTH = 8

    class << self
      attr_writer :terminal_width

      def format(block)
        file_names   = block.files.map(&:name)
        max_bytesize = file_names.map(&:bytesize).max
        colmn_width  = (max_bytesize + TAB_WIDTH) & ~(TAB_WIDTH - 1)

        return file_names if terminal_width < (2 * colmn_width)

        tab_padded_file_names = file_names.map { |file_name| tab_padding(file_name, colmn_width) }
        number_of_columns     = (terminal_width / colmn_width).ceil

        split_into_cloumns_with_padding(tab_padded_file_names, number_of_columns).transpose.map { |line| line.join.strip }
      end

      private

      def terminal_width
        @terminal_width ||= `tput cols`.delete('^0-9').to_i
      end

      def tab_padding(name, width)
        # 文字列の表示幅を正確に求めるのは手間がかかるため、日本語を2バイトで表す EUC-JP に変換後の bytesize を用いることにした
        name_display_width = name.encode('EUC-JP').bytesize

        while ((name_display_width + TAB_WIDTH) & ~(TAB_WIDTH - 1)) <= width
          name += "\t"

          name_display_width += TAB_WIDTH
        end

        name
      end

      def split_into_cloumns_with_padding(array, number_of_columns)
        size_of_column = (array.size / number_of_columns.to_f).ceil

        array.each_slice(size_of_column).map do |column|
          column.fill(nil, column.size..size_of_column - 1)
        end
      end
    end
  end
end
