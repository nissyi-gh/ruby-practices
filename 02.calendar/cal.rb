require 'date'
require 'optparse'

CALENDER_WIDTH = 20
DAY_DIGIT = 2
FIRST_DAY_OF_MONTH = 1
MIN_YEAR = 1
MAX_YEAR = 9999
SATURDAY = 6

def add_error_text_to_errors_unless_valid_year(year, errors)
  return if year >= MIN_YEAR && year <= MAX_YEAR
  errors << "cal: year `#{year}' not in range #{MIN_YEAR}..#{MAX_YEAR}"
end

def add_error_text_to_errors_unless_valid_month(month, errors)
  return if month >= 1 && month <= 12
  errors << "cal: #{month} is neither a month number (1..12) nor a name"
end

def puts_error_and_exit_if_exist_any_errors(errors)
  return unless errors.first
  errors.each do |e|
    puts e
  end

  exit
end

def generate_dates(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  (first_date..last_date).to_a
end

def add_blank_to_days_array_for_start_sunday(days, start_day_of_week)
  # 月初の曜日を合わせて出力できるようにdays配列へ空文字を追加
  start_day_of_week.times do
    days.unshift("")
  end

  days.map {|d| d.to_s.rjust(DAY_DIGIT) }
end

def puts_month_year_day_of_week(year, month)
  puts "#{month}月 #{year}".center(CALENDER_WIDTH)
  puts "日 月 火 水 木 金 土"
end

def print_day(year, month, d, today, i)
  # 今日と日付が同じなら反転させる
  if d != "  " && today == Date.new(year, month, d.to_i)
    print "\e[47m" + d + "\e[0m"
  else
    print d
  end
end

# 土曜以外
def print_blank(i)
  print " " unless i == SATURDAY
end

def print_calender(today, dates)
  week = []

  dates.each do |date|
    week << date.day.to_s.rjust(2)

    next unless date.saturday?

    puts week.join(" ").rjust(CALENDER_WIDTH)
    week = []
  end
  puts week.join(" ").ljust(CALENDER_WIDTH)
end

today = Date.today
opt = OptionParser.new
opt.on('-m')
opt.on('-y')
params = ARGV.getopts("", "y:#{today.year}", "m:#{today.month}")
year = params["y"].to_i
month = params["m"].to_i
errors = []

add_error_text_to_errors_unless_valid_year(year, errors)
add_error_text_to_errors_unless_valid_month(month, errors)
puts_error_and_exit_if_exist_any_errors(errors)
puts_month_year_day_of_week(year, month)
dates = generate_dates(year, month)
start_day_of_week = Date.new(year, month, FIRST_DAY_OF_MONTH).wday
# days = add_blank_to_days_array_for_start_sunday(days, start_day_of_week)
print_calender(today, dates)
# calコマンドは最後に改行を挟む
puts
