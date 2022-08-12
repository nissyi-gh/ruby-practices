# frozen_string_literal: true

require 'pathname'
require 'optparse'

PRINT_WIDTH = 8

def main
  params = parse_options

  if ARGV.any?
    results = {}

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

    print_from_path_names(results, params)
  else
    stdin = $stdin
    stdin = File.pipe?(stdin) ? stdin.to_a : stdin.readlines

    print_from_pipe_or_stdin(stdin.join, params)
  end
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

def print_from_path_names(results, params)
  totals = { l: 0, w: 0, c: 0 }

  results.each do |path_name, result|
    if result.instance_of?(String)
      puts result
    else
      print_after_rjust(result[:l], params[:l])
      print_after_rjust(result[:w], params[:w])
      print_after_rjust(result[:c], params[:c])
      print ' '
      puts path_name

      %i[l w c].each do |key|
        totals[key] += result[key]
      end
    end
  end

  return unless ARGV.size >= 2

  print_after_rjust(totals[:l], params[:l])
  print_after_rjust(totals[:w], params[:w])
  print_after_rjust(totals[:c], params[:c])
  puts ' total'
end

def print_from_pipe_or_stdin(stdin, params)
  print_after_rjust(stdin.count("\n"), params[:l])
  print_after_rjust(stdin.split.size, params[:w])
  print_after_rjust(stdin.bytesize, params[:c])
  puts
end

main if __FILE__ == $PROGRAM_NAME
