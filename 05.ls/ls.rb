# frozen_string_literal: true

require 'optparse'
require 'pathname'

class Ls
  @options = {}
  @path_names = []

  class << self
    attr_reader :options, :path_names

    def main
      parse_option
      parse_path
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
end

Ls.main
