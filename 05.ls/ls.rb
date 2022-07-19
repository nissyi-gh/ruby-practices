# frozen_string_literal: true

require 'optparse'

class Ls
  @options = {}

  class << self
    attr_reader :options

    def main
      parse_option
    end

    def parse_option
      opt = OptionParser.new
      opt.on('-a')
      opt.on('-r')
      opt.on('-l')
      opt.parse!(ARGV, into: @options)
    end

    def clear_options
      @options.clear
    end
  end
end

Ls.main
