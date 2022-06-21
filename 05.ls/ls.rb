require 'io/console/size'
LIST_COLUMNS = 3

def without_option(path_name)
  file_names = load_file_names(path_name)
  console_width = IO.console_size[1]

  file_name_width = configure_file_name_width(file_names)
  output_columns = configure_output_columns(file_name_width, console_width)
  list_height = (file_names.size.to_f / output_columns).ceil

  output_style_file_names = format_file_names(file_names.sort, list_height)
  print_file_names(list_height, output_style_file_names, file_name_width)
end

def load_file_names(path_name)
  file_names = []
  Dir.children(path_name).each do |file_name|
    file_names << file_name unless file_name[0] == '.'
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

  until file_name_width * LIST_COLUMNS < console_width || output_columns == 1
    output_columns -= 1
  end

  output_columns
end

def format_file_names(sort_file_names, list_height)
  column = []
  outputs = []

  sort_file_names.each do |file_name|
    column << file_name
    if column.size == list_height || sort_file_names.last == file_name
      outputs << column
      # column.clearをするとoutputsに入れた中身自体が消えてしまう
      column = []
    end
  end

  outputs
end

def print_file_names(list_height, output_style_file_names, file_name_width)
  list_height.times do |n|
    output_style_file_names.each do |file_name|
      print "#{file_name[n].ljust(file_name_width + 2)}" if file_name[n]
    end
    puts
  end
end

path_name = ARGV[0] || '.'
without_option(path_name)
