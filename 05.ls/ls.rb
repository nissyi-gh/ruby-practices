def no_option(path_name='.')
  file_names = []
  Dir.children(path_name).each do |file_name|
    file_names << file_name unless file_name[0] == '.'
  end

  file_names.join(' ')
end

no_option
