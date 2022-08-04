# frozen_string_literal: true

require 'pathname'
require 'optparse'

def main
  print_width = 8
  params = parse_options
  path_names = parse_paths

  path_names.each do |path_name|
    print parse_file_lines(path_name, params).to_s.rjust(print_width) if params[:l]
    print parse_word_count(path_name, params).to_s.rjust(print_width) if params[:w]
    print read_file_size(path_name, params).to_s.rjust(print_width) if params[:c]
    print ' '
    puts path_name
  end

  if path_names.size >= 2
    print params[:l_total].to_s.rjust(print_width) if params[:l]
    print params[:w_total].to_s.rjust(print_width) if params[:w]
    print params[:c_total].to_s.rjust(print_width) if params[:c]
    puts ' total'
  end
end

def parse_options
  params = {}

  opt = OptionParser.new
  opt.on('-l') do
    params[:l] = true
    params[:l_total] = 0
  end
  opt.on('-w') do
    params[:w] = true
    params[:w_total] = 0
  end
  opt.on('-c') do
    params[:c] = true
    params[:c_total] = 0
  end
  opt.parse!(ARGV)

  params.empty? ? { l: true, l_total: 0, w: true, w_total: 0, c: true, c_total: 0 } : params
end

def parse_paths
  path_names = []

  ARGV.each do |path|
    if !File.exist?(path)
      puts "wc: #{path}: open: No such file or directory"
    elsif File.directory?(path)
      puts "wc: #{path}: read: Is a directory"
    else
      path_names << Pathname.new(path)
    end
  end

  path_names
end

def parse_file_lines(path_name, params)
  line_count = 0

  path_name.each_line { line_count += 1 }
  params[:l_total] += line_count

  line_count
end

def parse_word_count(path_name, params)
  word_count = 0

  path_name.each_line do |line|
    word_count += line.split.size
  end
  params[:w_total] += word_count

  word_count
end

def read_file_size(path_name, params)
  file_size = File.size(path_name)
  params[:c_total] += file_size

  file_size
end

main
