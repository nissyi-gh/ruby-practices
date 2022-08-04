# frozen_string_literal: true

require 'pathname'

def main
  print_width = 8
  path_names = parse_paths

  path_names.each do |path_name|
    print parse_file_lines(path_name).to_s.rjust(print_width)
    print parse_word_count(path_name).to_s.rjust(print_width)
    print File.size(path_name).to_s.rjust(print_width)
    print ' '
    puts path_name
  end
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

def parse_file_lines(path_name)
  line_count = 0

  path_name.each_line { line_count += 1 }

  line_count
end

def parse_word_count(path_name)
  word_count = 0

  path_name.each_line do |line|
    word_count += line.split.size
  end

  word_count
end

main
