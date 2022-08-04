# frozen_string_literal: true

require 'pathname'

def main
  path_names = parse_paths

  path_names.each do |path_name|
    print File.size(path_name)
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

main
