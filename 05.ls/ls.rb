# frozen_string_literal: true

require 'io/console/size'
require 'pathname'
LIST_COLUMNS = 3

def without_option(path)
  path_name = Pathname.new(path)
  return puts "ls: #{path_name}: No such file or directory" unless valid_path_name?(path_name)

  file_names = load_file_names(path_name)
  console_width = IO.console_size[1]

  file_name_width = configure_file_name_width(file_names)
  output_columns = configure_output_columns(file_name_width, console_width)
  list_height = (file_names.size.to_f / output_columns).ceil

  output_style_file_names = format_file_names(file_names.sort, list_height)
  print_file_names(list_height, output_style_file_names, file_name_width)
end

def valid_path_name?(path_name)
  path_name.exist?
end

def load_file_names(path_name)
  file_names = []

  if path_name.directory?
    Dir.children(path_name).each do |file_name|
      file_names << file_name unless file_name[0] == '.'
    end
  else
    file_names << path_name.to_s
  end
  file_names
end

def configure_file_name_width(file_names)
  file_name_width = 0

  file_names.each do |file_name|
    file_name_width = file_name.size if file_name_width < file_name.size
  end

  file_name_width
end

def configure_output_columns(file_name_width, console_width)
  output_columns = LIST_COLUMNS

  output_columns -= 1 until file_name_width * LIST_COLUMNS < console_width || output_columns == 1

  output_columns
end

def format_file_names(sort_file_names, list_height)
  column = []
  outputs = []

  sort_file_names.each do |file_name|
    column << file_name
    next if column.size != list_height && sort_file_names.last != file_name

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

path = ARGV[0] || '.'
without_option(path)
