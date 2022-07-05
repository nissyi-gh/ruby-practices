# frozen_string_literal: true

require 'io/console/size'
require 'pathname'
require 'optparse'
DEFAULT_COLUMN_COUNT = 3
CONSOLE_WIDTH = IO.console_size[1]

def main
  params = parse_command_option
  path_names = parse_path

  simulate_ls_command(path_names, params)
end

def parse_command_option
  params = {}
  opt = OptionParser.new

  opt.on('-a', params) { params[:a] = true }
  opt.on('-r', params) { params[:r] = true }

  opt.order!
  params
end

def parse_path
  path_names = []

  return [Pathname.new('.')] if ARGV.empty?

  ARGV.each do |path|
    path_name = Pathname.new(path)

    if path_name.exist?
      path_names << path_name
    else
      puts "ls: #{path_name}: No such file or directory"
    end
  end

  path_names.sort
end

def simulate_ls_command(path_names, params)
  path_names.each do |path_name|
    next puts path_name.to_s if path_name.file?

    file_names = load_file_names(path_name, params)
    next if file_names.empty?

    puts "#{path_name}:" if path_names.size > 1 || ARGV.size > 1
    print_file_names(file_names)
    puts unless path_name == path_names.last
  end
end

def load_file_names(path_name, params)
  file_names = params[:a] ? Dir.entries(path_name).sort : Dir.glob('*', base: path_name)
  file_names.reverse! if params[:r]
end

def configure_column_count(file_name_width)
  column_count = DEFAULT_COLUMN_COUNT

  column_count -= 1 while file_name_width * DEFAULT_COLUMN_COUNT > CONSOLE_WIDTH && column_count > 1

  column_count
end

def format_file_names(file_names, list_height)
  column = []
  outputs = []

  file_names.each do |file_name|
    column << file_name
    next if column.size != list_height && file_names.last != file_name

    outputs << column
    # column.clearをするとoutputsに入れた中身自体が消えてしまう
    column = []
  end

  outputs
end

def print_file_names(file_names)
  file_name_width = file_names.map(&:length).max
  column_count = configure_column_count(file_name_width)
  list_height = (file_names.size.to_f / column_count).ceil
  output_style_file_names = format_file_names(file_names, list_height)

  list_height.times do |n|
    output_style_file_names.each do |file_name|
      print file_name[n].ljust(file_name_width + 2).to_s if file_name[n]
    end
    puts
  end
end

main
