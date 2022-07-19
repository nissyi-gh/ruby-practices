# frozen_string_literal: true

require 'optparse'
require 'pathname'

class Ls
  @options = {}
  @path_names = []
  @files = []

  class << self
    attr_reader :options, :path_names
    attr_accessor :files

    def main
      parse_option
      parse_path

      @path_names.each do |path_name|
        load_files(path_name)
        print_files
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

    def load_files(path_name)
      @files =
        if @options[:a]
          Dir.entries(path_name).sort
        else
          Dir.glob('*', base: path_name)
        end

      @files.reverse! if @options[:r]
    end

    def print_files
      puts @files
    end

    def clear_options
      @options.clear
    end

    def clear_path_names
      @path_names.clear
    end
  end
end

Ls.main
