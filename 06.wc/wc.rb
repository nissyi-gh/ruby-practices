# frozen_string_literal: true

require 'pathname'
require 'optparse'

PRINT_WIDTH = 8

def main
  params = parse_options
  results = {}

  if ARGV.any?
    ARGV.each do |path|
      results[path.to_sym] =
        if !File.exist?(path)
          "wc: #{path}: open: No such file or directory"
        elsif File.directory?(path)
          "wc: #{path}: read: Is a directory"
        else
          File.open(path, 'r') do |file|
            file.flock(File::LOCK_SH)
            read_file_properties(file.read)
          end
        end
    end
  else
    results[:stdin] = read_file_properties($stdin.read)
  end

  print_results(results, params)
end

def parse_options
  params = {}

  opt = OptionParser.new
  opt.on('-l') { params[:l] = true }
  opt.on('-w') { params[:w] = true }
  opt.on('-c') { params[:c] = true }
  opt.parse!(ARGV)

  params.empty? ? { l: true, w: true, c: true } : params
end

def print_after_rjust(target, flag_param)
  print target.to_s.rjust(PRINT_WIDTH) if flag_param
end

def read_file_properties(file)
  {
    l: file.count("\n"),
    w: file.split.size,
    c: file.bytesize
  }
end

def print_results(results, params)
  totals = { l: 0, w: 0, c: 0 }

  results.each do |file_name, result|
    if result.instance_of?(String)
      puts result
    else
      %i[l w c].each do |key|
        print_after_rjust(result[key], params[key])
        totals[key] += result[key]
      end

      return puts if file_name == :stdin

      puts " #{file_name}"
    end
  end

  return unless ARGV.size >= 2

  %i[l w c].each { |key| print_after_rjust(totals[key], params[key]) }
  puts ' total'
end

main if __FILE__ == $PROGRAM_NAME
