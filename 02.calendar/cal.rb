require 'date'
require 'optparse'

CALENDER_WIDTH = 20
DAY_DIGIT = 2
FIRST_DAY_OF_MONTH = 1
MIN_YEAR = 1
MAX_YEAR = 9999
JANUARY = 1
DECENMBER = 12
SATURDAY = 6

def add_error_text_to_errors_unless_valid_year(year, errors)
  return if year >= MIN_YEAR && year <= MAX_YEAR
  errors << "cal: year `#{year}' not in range #{MIN_YEAR}..#{MAX_YEAR}"
end

def add_error_text_to_errors_unless_valid_month(month, errors)
  return if month >= JANUARY && month <= DECENMBER
  errors << "cal: #{month} is neither a month number (#{JANUARY}..#{DECENMBER}) nor a name"
end

def puts_error_and_exit_if_exist_any_errors(errors)
  return unless errors.first
  errors.each do |e|
    puts e
  end

  exit
end

# 指定した年月の日付配列を返す
def return_days_array_of_month(year, month)
  last_day = Date.new(year, month, -1).day
  (FIRST_DAY_OF_MONTH..last_day).to_a
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

def print_calender(year, month, today, days)
  until days.empty? do
    # 曜日相当の一時変数
    i = 0

    # 土曜日まで、かつ日付が存在している間は出力
    while i <= SATURDAY && days.first do
      d = days.shift
      print_day(year, month, d, today, i)
      print_blank(i)
      i += 1
    end

    # 土曜日まで出力したら改行
    puts
  end
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
days = return_days_array_of_month(year, month)
start_day_of_week = Date.new(year, month, FIRST_DAY_OF_MONTH).wday
days = add_blank_to_days_array_for_start_sunday(days, start_day_of_week)
print_calender(year, month, today, days)
# calコマンドは最後に改行を挟む
puts
