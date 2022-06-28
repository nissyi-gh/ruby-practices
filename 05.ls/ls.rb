# frozen_string_literal: true

require 'io/console/size'
require 'pathname'
require 'optparse'
DEFAULT_COLUMN_COUNT = 3


def simulate_ls_command(path_names, params)
  if params[:a]
    with_all_option(path_names)
  else
    without_option(path_names)
  end
end

def without_option(path_names)
  console_width = IO.console_size[1]

  path_names.each_with_index do |path_name, index|
    puts "#{path_name}:" if path_names.size > 1

    file_names = load_file_names(path_name)

    next if file_names.empty?

    file_name_width = file_names.map(&:length).max
    column_count = configure_column_count(file_name_width, console_width)
    list_height = (file_names.size.to_f / column_count).ceil
    output_style_file_names = format_file_names(file_names, list_height)
    print_file_names(list_height, output_style_file_names, file_name_width)
  end
end

def with_all_option(path_names)
  console_width = IO.console_size[1]

  path_names.each_with_index do |path_name, index|
    puts "#{path_name}:" if path_names.size > 1

    file_names = Dir.entries(path_name).sort

    next if file_names.empty?

    file_name_width = file_names.map(&:length).max
    column_count = configure_column_count(file_name_width, console_width)
    list_height = (file_names.size.to_f / column_count).ceil
    output_style_file_names = format_file_names(file_names, list_height)
    print_file_names(list_height, output_style_file_names, file_name_width)

    puts unless path_name == path_names.last
  end
end

def parse_command_option
  params = Hash.new
  opt = OptionParser.new

  opt.on('-a', params) {|v| params[:a] = true }

  opt.order!
  params
end

def parse_path
  path_names = []
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

def valid_path_name?(path_name)
  path_name.exist?
end

def load_file_names(path_name, flags = 0)
  # この先 ls -aなどで隠しファイルも表示できるようflagsを受け取れるようにしておく
  Dir.glob('*', flags, base: path_name)
end

def configure_column_count(file_name_width, console_width)
  column_count = DEFAULT_COLUMN_COUNT

  column_count -= 1 while file_name_width * DEFAULT_COLUMN_COUNT > console_width && column_count > 1

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

def print_file_names(list_height, output_style_file_names, file_name_width)
  list_height.times do |n|
    output_style_file_names.each do |file_name|
      print file_name[n].ljust(file_name_width + 2).to_s if file_name[n]
    end
    puts
  end
end

params = parse_command_option
path_names = parse_path
simulate_ls_command(path_names, params)
