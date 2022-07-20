# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'io/console/size'

class Ls
  @options = {}
  @path_names = []
  @column_count = 3
  @console_width = IO.console_size[1]

  class << self
    attr_reader :options, :path_names, :column_count, :console_width

    def main
      parse_option
      parse_path

      @path_names.each do |path_name|
        Ls.new(path_name)
      end
    end

    def parse_option
      opt = OptionParser.new
      opt.on('-a')
      opt.on('-r')
      opt.on('-l')
      opt.parse!(ARGV, into: @options)
    end

    def parse_path
      return @path_names << Pathname.new('.') if ARGV.empty?

      ARGV.each do |path|
        path_name = Pathname.new(path)

        @path_names <<
          if path_name.exist?
            path_name
          else
            "ls: #{path_name}: No such file or directory"
          end
      end
    end

    def clear_options
      @options.clear
    end

    def clear_path_names
      @path_names.clear
    end
  end

  attr_accessor :files, :list_height, :file_name_width
  attr_reader :path_name

  def initialize(path_name)
    @files = load_files(path_name)
    @list_height = configure_list_height
    @file_name_width = configure_file_name_width

    print_files
  end

  def load_files(path_name)
    files =
      if Ls.options[:a]
        Dir.entries(path_name).sort
      else
        Dir.glob('*', base: path_name)
      end

    Ls.options[:r] ? files.reverse : files
  end

  def configure_list_height
    @list_height = (@files.size.to_f / Ls.column_count).ceil
  end

  def configure_file_name_width
    @file_name_width = @files.map(&:length).max + 2
  end

  def print_files
    @list_height.times do |row|
      0...Ls.column_count.times do |column|
        index = row + column * @list_height
        print @files[index].ljust(@file_name_width) if @files[index]
      end
      puts
    end
  end
end

Ls.main
