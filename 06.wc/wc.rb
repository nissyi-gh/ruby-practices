# frozen_string_literal: true

require 'pathname'
require 'optparse'

PRINT_WIDTH = 8

def main
  params = parse_options
  results = {}

  if ARGV.any?
    ARGV.each do |path|
      results[path.to_sym] =
        if !File.exist?(path)
          "wc: #{path}: open: No such file or directory"
        elsif File.directory?(path)
          "wc: #{path}: read: Is a directory"
        else
          path_name = Pathname.new(path)
          parse_from_path_name(path_name)
        end
    end
  else
    stdin = $stdin
    stdin = File.pipe?(stdin) ? stdin.to_a : stdin.readlines

    results[:stdin] = parse_from_stdin(stdin.join)
  end

  print_results(results, params)
end

def parse_options
  params = {}

  opt = OptionParser.new
  opt.on('-l') { params[:l] = true }
  opt.on('-w') { params[:w] = true }
  opt.on('-c') { params[:c] = true }
  opt.parse!(ARGV)

  params.empty? ? { l: true, w: true, c: true } : params
end

def print_after_rjust(target, flag_param)
  print target.to_s.rjust(PRINT_WIDTH) if flag_param
end

def parse_from_path_name(path_name)
  {
    l: path_name.each_line.sum { 1 },
    w: path_name.each_line.sum { |line| line.split.size },
    c: File.size(path_name)
  }
end

def parse_from_stdin(stdin)
  {
    l: stdin.count("\n"),
    w: stdin.split.size,
    c: stdin.bytesize
  }
end

def print_results(results, params)
  totals = { l: 0, w: 0, c: 0 }

  results.each do |file_name, result|
    if result.instance_of?(String)
      puts result
    else
      %i[l w c].each do |key|
        print_after_rjust(result[key], params[key])
        totals[key] += result[key]
      end

      return puts if file_name == :stdin

      puts " #{file_name}"
    end
  end

  return unless ARGV.size >= 2

  %i[l w c].each { |key| print_after_rjust(totals[key], params[key]) }
  puts ' total'
end

main if __FILE__ == $PROGRAM_NAME
