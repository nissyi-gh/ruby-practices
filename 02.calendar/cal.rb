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

def puts_month_year_day_of_week(year, month)
  puts "#{month}月 #{year}".center(CALENDER_WIDTH)
  puts "日 月 火 水 木 金 土"
end

def formatted_day(date, today)
  if date == today
    "\e[47m#{date.day.to_s.rjust(DAY_DIGIT)}\e[0m"
  else
    date.day.to_s.rjust(DAY_DIGIT)
  end
end

def print_calender(today, dates)
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
print_calender(today, dates)
