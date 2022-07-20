# frozen_string_literal: true

require 'etc'
require 'time'

module LsL
  def ls_l
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
  end

  def load_file_properties(file_stat, file)
    file_properties = {}

    file_properties[:file_type] = convert_file_type(file_stat.ftype)
    file_properties[:permission] = convert_permission(file_stat.mode.digits(8)[0..2].reverse)
    file_properties[:symbolic_link] = file_stat.nlink
    file_properties[:owner_name] = Etc.getpwuid(file_stat.uid).name
    file_properties[:group_name] = Etc.getgrgid(file_stat.gid).name
    file_properties[:size] = file_stat.size
    file_properties[:mtime] = file_stat.mtime.strftime('%_2m %_d %H:%M')
    file_properties[:name] = file
    file_properties[:read_link] = File.readlink("#{@path_name}/#{file_name}") if file_stat.ftype == 'link'
    file_properties
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
end
