# frozen_string_literal: true

require_relative './file'

module Ls
  class Block
    attr_reader :files, :directory_path

    def initialize(file_names, directory_path = nil)
      @files          = file_names.map { |file_name| File.new(file_name, directory_path) }
      @directory_path = directory_path
    end
  end
end
