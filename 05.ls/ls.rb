# frozen_string_literal: true

require 'io/console/size'
require 'pathname'
require 'etc'
require 'optparse'
require 'time'
DEFAULT_COLUMN_COUNT = 3

def main
  params = {}

  parse_option(params)
  path_names = parse_path

  if params[:l]
    with_l_option(path_names)
  else
    # 後でpath_nameから実行できるようにする
    # ls_command_simulate_without_option(path)
  end
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

def ls_command_simulate_without_option(path)
  path_name = Pathname.new(path)
  return puts "ls: #{path_name}: No such file or directory" unless valid_path_name?(path_name)

  file_names = load_file_names(path_name)
  return if file_names.empty?

  console_width = IO.console_size[1]

  file_name_width = file_names.map(&:length).max
  column_count = configure_column_count(file_name_width, console_width)
  list_height = (file_names.size.to_f / column_count).ceil

  output_style_file_names = format_file_names(file_names, list_height)
  print_file_names(list_height, output_style_file_names, file_name_width)
end

def parse_option(params)
  opt = OptionParser.new

  opt.on('-l') { params[:l] = true }

  opt.parse!(ARGV)
end

def valid_path_name?(path_name)
  path_name.exist?
end

def load_file_names(path_name, flags = 0)
  return [path_name.to_s] if path_name.file?

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

def with_l_option(path_names)
  total_size = 0
  outputs = []
  symbolic_link_width = 0
  size_width = 0

  path_names.each do |path_name|
    outputs << "#{path_name}:" if path_names.size >= 2
    file_names = load_file_names(path_name)

    file_names.each do |file_name|
      file_stat = File.stat("#{path_name}/#{file_name}")
      total_size += file_stat.blocks
      outputs << parse_file_property(file_stat, file_name)

      symbolic_link_width = [outputs.last[:symbolic_link].digits.size, symbolic_link_width].max
      size_width = [outputs.last[:size].digits.size, size_width].max
    end
  end

  print_details(total_size, outputs, symbolic_link_width, size_width)
end

def parse_file_property(file_stat, file_name)
  file_properties = {}

  file_properties[:file_type] = format_file_type(file_stat.ftype)
  file_properties[:permission] = convert_permission(file_stat.mode.digits(8)[0..2].reverse)
  file_properties[:symbolic_link] = file_stat.nlink
  file_properties[:owner_name] = Etc.getpwuid(file_stat.uid).name
  file_properties[:group_name] = Etc.getgrgid(file_stat.gid).name
  file_properties[:size] = file_stat.size
  file_properties[:mtime] = file_stat.mtime.strftime('%_2m %_d %H:%M')
  file_properties[:name] = file_name

  file_properties
end

def print_details(total_size, outputs, symbolic_link_width, size_width)
  puts "total #{total_size}"

  outputs.each do |file_properties|
    print file_properties[:file_type]
    print file_properties[:permission]
    print '  '
    print format("%#{symbolic_link_width}d", file_properties[:symbolic_link])
    print ' '
    print file_properties[:owner_name]
    print '  '
    print file_properties[:group_name]
    print '  '
    print format("%#{size_width}d", file_properties[:size])
    print ' '
    print file_properties[:mtime]
    print ' '
    puts file_properties[:name]
  end
end

def format_file_type(file_type)
  file_types = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l'
  }

  file_types[file_type]
end

def convert_permission(modes)
  outputs = ''
  permissions = {
    7 => 'rwx',
    6 => 'rw-',
    5 => 'r-x',
    4 => 'r--',
    3 => '-wx',
    2 => '-w-',
    1 => '--x',
    0 => '---'
  }

  modes.each do |mode|
    outputs += permissions[mode]
  end

  outputs
end
main
