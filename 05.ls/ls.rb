LIST_WIDTH = 3

def without_option(path_name)
  file_names = []
  Dir.children(path_name).each do |file_name|
    file_names << file_name unless file_name[0] == '.'
  end

  sort_file_names = file_names.sort
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

  list_height.times do |n|
    outputs.each do |output|
      print "#{output[n]} " if output[n]
    end
    puts
  end
end

path_name = ARGV[0] || '.'
without_option(path_name)
