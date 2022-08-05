# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'io/console/size'
require_relative './lib/ls_l'

class Ls
  include LsL

  @options = {}
  @path_names = []
  @column_count = 3
  @console_width = IO.console_size[1]

  class << self
    attr_reader :options, :path_names, :column_count, :console_width

    def main
      parse_option
      parse_path

      @path_names.each do |path_name|
        if path_name.instance_of?(String)
          puts path_name
        else
          puts "#{path_name}:" if @path_names.size >= 2
          Ls.new(path_name)
          puts if @path_names.size >= 2 && path_name != @path_names.last
        end
      end
    end

    def clear_options
      @options.clear
    end

    def clear_path_names
      @path_names.clear
    end

    private

    def parse_option
      opt = OptionParser.new
      opt.on('-a')
      opt.on('-r')
      opt.on('-l')
      opt.parse!(ARGV, into: @options)
    end

    def parse_path
      return @path_names << Pathname.new('.') if ARGV.empty?

      ARGV.each do |path|
        path_name = Pathname.new(path)

        @path_names <<
          if path_name.exist?
            path_name
          else
            "ls: #{path_name}: No such file or directory"
          end
      end
    end
  end

  attr_accessor :files, :list_height, :file_name_width, :total_block_size, :symbolic_link_width, :size_width
  attr_reader :path_name

  def initialize(path_name)
    @path_name = path_name
    @files = load_files
    return unless @files.any?

    @symbolic_link_width = 0
    @size_width = 0
    @total_block_size = 0
    @list_height = configure_list_height
    @file_name_width = configure_file_name_width

    print_files
  end

  private

  def load_files
    files =
      if @path_name.file?
        [@path_name.to_s]
      elsif Ls.options[:a]
        Dir.entries(@path_name).sort
      else
        Dir.glob('*', base: @path_name)
      end

    Ls.options[:r] ? files.reverse : files
  end

  def configure_list_height
    @list_height = (@files.size.to_f / Ls.column_count).ceil
  end

  def configure_file_name_width
    @file_name_width = @files.map(&:length).max + 2
  end

  def print_files
    if Ls.options[:l]
      ls_l
    else
      @list_height.times do |row|
        0...Ls.column_count.times do |column|
          index = row + column * @list_height
          print @files[index].ljust(@file_name_width) if @files[index]
        end
        puts
      end
    end
  end
end

Ls.main
=======
require 'io/console/size'
require 'pathname'
require 'etc'
require 'optparse'
require 'time'

DEFAULT_COLUMN_COUNT = 3
CONSOLE_WIDTH = IO.console_size[1]

def main
  params = {}

  parse_option(params)
  path_names = parse_path

  if params[:l]
    ls_command_simulate_with_l_option(path_names)
  else
    ls_command_simulate_without_option(path_names)
  end
end

def parse_option(params)
  opt = OptionParser.new

  opt.on('-a', params) { params[:a] = true }
  opt.on('-r', params) { params[:r] = true }

  opt.parse!(ARGV)
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

def parse_file_property(file_stat, file_name, path_name)
  file_properties = {}

  file_properties[:file_type] = convert_file_type(file_stat.ftype)
  file_properties[:permission] = convert_permission(file_stat.mode.digits(8)[0..2].reverse)
  file_properties[:symbolic_link] = file_stat.nlink
  file_properties[:owner_name] = Etc.getpwuid(file_stat.uid).name
  file_properties[:group_name] = Etc.getgrgid(file_stat.gid).name
  file_properties[:size] = file_stat.size
  file_properties[:mtime] = file_stat.mtime.strftime('%_2m %_d %H:%M')
  file_properties[:name] = file_name
  file_properties[:read_link] = File.readlink("#{path_name}/#{file_name}") if file_stat.ftype == 'link'
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
    print file_properties[:name]
    puts file_properties[:read_link] ? " -> #{file_properties[:read_link]}" : ''
  end
end

def convert_file_type(file_type)
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

def ls_command_simulate_with_l_option(path_names)
  path_names.each do |path_name|
    outputs = []
    symbolic_link_width = 0
    size_width = 0
    total_size = 0
    file_names = load_file_names(path_name)

    file_names.each do |file_name|
      file_stat = File.lstat("#{path_name}/#{file_name}")
      total_size += file_stat.blocks
      outputs << parse_file_property(file_stat, file_name, path_name)

      symbolic_link_width = [outputs.last[:symbolic_link].digits.size, symbolic_link_width].max
      size_width = [outputs.last[:size].digits.size, size_width].max
    end

    puts "#{path_name}:" if path_names.size >= 2
    print_details(total_size, outputs, symbolic_link_width, size_width)
    puts if path_names.size >= 2 && path_name != path_names.last
  end
end

def ls_command_simulate_without_option(path_names)
  path_names.each do |path|
    path_name = Pathname.new(path)
    file_names = load_file_names(path_name)
    next if file_names.empty?

    console_width = IO.console_size[1]

    file_name_width = file_names.map(&:length).max
    column_count = configure_column_count(file_name_width, console_width)
    list_height = (file_names.size.to_f / column_count).ceil

    output_style_file_names = format_file_names(file_names, list_height)

    puts "#{path_name}:" if path_names.size >= 2
    print_file_names(list_height, output_style_file_names, file_name_width)
    puts if path_names.size >= 2 && path_name != path_names.last
  end
end

main
