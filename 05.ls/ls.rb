# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'io/console/size'
require 'etc'
require 'time'

class Ls
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
          Ls.new(path_name)
        end
      end
    end

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

    def clear_options
      @options.clear
    end

    def clear_path_names
      @path_names.clear
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
  end

  attr_accessor :files, :list_height, :file_name_width, :total_size, :symbolic_link_width, :size_width
  attr_reader :path_name

  def initialize(path_name)
    @path_name = path_name
    @symbolic_link_width = 0
    @size_width = 0
    @total_size = 0
    @files = load_files
    @list_height = configure_list_height
    @file_name_width = configure_file_name_width

    print_files
  end

  def load_files
    files =
      if Ls.options[:a]
        Dir.entries(@path_name).sort
      else
        Dir.glob('*', base: @path_name)
      end

    Ls.options[:r] ? files.reverse : files
  end

  def load_file_properties(file_stat, file)
    file_properties = {}

    file_properties[:file_type] = Ls.convert_file_type(file_stat.ftype)
    file_properties[:permission] = Ls.convert_permission(file_stat.mode.digits(8)[0..2].reverse)
    file_properties[:symbolic_link] = file_stat.nlink
    file_properties[:owner_name] = Etc.getpwuid(file_stat.uid).name
    file_properties[:group_name] = Etc.getgrgid(file_stat.gid).name
    file_properties[:size] = file_stat.size
    file_properties[:mtime] = file_stat.mtime.strftime('%_2m %_d %H:%M')
    file_properties[:name] = file
    file_properties[:read_link] = File.readlink("#{@path_name}/#{file_name}") if file_stat.ftype == 'link'
    file_properties
  end

  def configure_list_height
    @list_height = (@files.size.to_f / Ls.column_count).ceil
  end

  def configure_file_name_width
    @file_name_width = @files.map(&:length).max + 2
  end

  def print_files
    if Ls.options[:l]
      outputs = []
      @files.each do |file|
        file_stat = File.lstat("#{@path_name}/#{file}")
        @total_size += file_stat.blocks
        outputs << load_file_properties(file_stat, file)
        @symbolic_link_width = [outputs.last[:symbolic_link].digits.size, @symbolic_link_width].max
        @size_width = [outputs.last[:size].digits.size, @size_width].max
      end

      puts "total #{@total_size}"

      outputs.each do |output|
        print_details(output)
      end
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

  def print_details(file_properties)
    print file_properties[:file_type]
    print file_properties[:permission]
    print '  '
    print format("%#{@symbolic_link_width}d", file_properties[:symbolic_link])
    print ' '
    print file_properties[:owner_name]
    print '  '
    print file_properties[:group_name]
    print '  '
    print format("%#{@size_width}d", file_properties[:size])
    print ' '
    print file_properties[:mtime]
    print ' '
    print file_properties[:name]
    puts file_properties[:read_link] ? " -> #{file_properties[:read_link]}" : ''
  end
end

Ls.main
