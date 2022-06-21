require 'io/console/size'
LIST_WIDTH = 3

def without_option(path_name)
  file_names = load_file_names(path_name)
  sort_file_names = file_names.sort
  console_width = IO.console_size
  outputs = []
  rows = []
  list_height = (file_names.size.to_f / LIST_WIDTH).ceil

  sort_file_names.each do |file_name|
    rows << file_name
    if rows.size % list_height == 0 || sort_file_names.last == file_name
      outputs << rows
      rows = []
    end
  end

  file_name_width = configure_file_name_width(outputs)

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

def configure_file_name_width(outputs)
  file_name_width = 0

  outputs.each do |n|
    n.each do |file_name|
      file_name_width = file_name.size if file_name_width < file_name.size
    end
  end

  file_name_width
end

path_name = ARGV[0] || '.'
without_option(path_name)
