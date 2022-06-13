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
  params = ARGV.getopts("", "y:#{today.year}", "m:#{today.month}")
  year = params["y"].to_i
  month = params["m"].to_i

  unless valid_year?(year)
    puts "cal: year `#{year}' not in range #{MIN_YEAR}..#{MAX_YEAR}"
    return
  end

  unless valid_month?(month)
    puts "cal: #{month} is neither a month number (1..12) nor a name"
    return
  end

  calender_header(year, month)
  dates = generate_dates(year, month)
  calender_body(today, dates)
end

def valid_year?(year)
  year >= MIN_YEAR && year <= MAX_YEAR
end

def valid_month?(month)
  month >= 1 && month <= 12
end

def generate_dates(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  (first_date..last_date).to_a
end

def calender_header(year, month)
  puts "#{month}月 #{year}".center(CALENDER_WIDTH)
  puts '日 月 火 水 木 金 土'
end

def formatted_day(date, today)
  if date == today
    "\e[47m#{date.day.to_s.rjust(DAY_DIGIT)}\e[0m"
  else
    date.day.to_s.rjust(DAY_DIGIT)
  end
end

def calender_body(today, dates)
  week = []

  dates.each do |date|
    week << formatted_day(date, today)

    next unless date.saturday?

    puts week.join(" ").rjust(CALENDER_WIDTH)
    week = []
  end

  puts week.join(" ")
  # 月末が土曜日の場合は、1行上のputsで改行を挟める。それ以外は以下のputsで意図的に挟む。
  puts unless dates.last.saturday?
end

main
