require 'io/console/size'
LIST_COLUMNS = 3

def without_option(path_name)
  file_names = load_file_names(path_name)
  sort_file_names = file_names.sort
  console_width = IO.console_size[1]
  outputs = []
  rows = []
  file_name_width = configure_file_name_width(file_names)
  output_columns = configure_output_columns(file_name_width, console_width)
  list_height = (file_names.size.to_f / output_columns).ceil

  sort_file_names.each do |file_name|
    rows << file_name
    if rows.size % list_height == 0 || sort_file_names.last == file_name
      outputs << rows
      rows = []
    end
  end

  list_height.times do |n|
    outputs.each do |output|
      print "#{output[n].ljust(file_name_width + 2)}" if output[n]
    end
    puts
  end
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

path_name = ARGV[0] || '.'
without_option(path_name)
