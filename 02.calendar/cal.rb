# frozen_string_literal: true

require 'date'
require 'optparse'

CALENDER_WIDTH = 20
DAY_DIGIT = 2
MIN_YEAR = 1
MAX_YEAR = 9999

def main
  today = Date.today
  opt = OptionParser.new
  opt.on('-m')
  opt.on('-y')
  params = ARGV.getopts('', "y:#{today.year}", "m:#{today.month}")
  year = params['y'].to_i
  month = params['m'].to_i

  unless valid_year?(year)
    puts "cal: year `#{year}' not in range #{MIN_YEAR}..#{MAX_YEAR}"
    return
  end

  unless valid_month?(month)
    puts "cal: #{month} is neither a month number (1..12) nor a name"
    return
  end

  print_calender_header(year, month)
  dates = generate_dates(year, month)
  print_calender_body(today, dates)
end

def valid_year?(year)
  (MIN_YEAR..MAX_YEAR).cover?(year)
end

def valid_month?(month)
  (1..12).cover?(month)
end

def generate_dates(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  (first_date..last_date).to_a
end

def print_calender_header(year, month)
  puts "#{month}月 #{year}".center(CALENDER_WIDTH)
  puts '日 月 火 水 木 金 土'
end

def format_day(date, today)
  day = date.day.to_s.rjust(DAY_DIGIT)

  date == today ? "\e[47m#{day}\e[0m" : day
end

def print_calender_body(today, dates)
  week = []

  dates.each do |date|
    week << format_day(date, today)

    if date.saturday?
      puts week.join(' ').rjust(CALENDER_WIDTH)
      week = []
    elsif dates.last == date
      puts week.join(' ')
    end
  end

  # calコマンドは最後に改行を挟む
  puts
end

main
