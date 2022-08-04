# frozen_string_literal: true

def main
  parse_paths
end

def parse_paths
  ARGV.each do |path|
    if !File.exist?(path)
      puts "wc: #{path}: open: No such file or directory"
    elsif File.directory?(path)
      puts "wc: #{path}: read: Is a directory"
    end
  end
end

main
