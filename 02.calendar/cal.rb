require 'date'
require 'optparse'

CALENDER_WIDTH = 20
DAY_DIGIT = 2
FIRST_DAY_OF_MONTH = 1

def validate_of_year(year)
  puts "Invalid year." unless year >= 1 && year <= 9999
end

def validate_of_month(month)
  puts "Invalid month." unless month >= 1 && month <= 12
end

# 指定した年月の日付配列を返す
def return_days_array_of_month(year, month)
  last_day = Date.new(year, month, -1).day
  (FIRST_DAY_OF_MONTH..last_day).to_a
end

def puts_month_year_day_of_week(year, month)
  puts "#{month}月 #{year}".center(CALENDER_WIDTH)
  puts "日 月 火 水 木 金 土"
end

today = Date.today
opt = OptionParser.new
opt.on('-m')
opt.on('-y')
params = ARGV.getopts("", "y:#{today.year}", "m:#{today.month}")
year = params["y"].to_i
month = params["m"].to_i

validate_of_year(year)
validate_of_month(month)
puts_month_year_day_of_week(year, month)
days = return_days_array_of_month(year, month)

# 月初の曜日を特定する
start_day_of_week = Date.new(year, month, FIRST_DAY_OF_MONTH).wday

# 月初の曜日を合わせて出力できるようにdays配列へ空文字を追加
start_day_of_week.times do
  days.unshift("")
end

# days配列の要素が存在する限りループ
until days.empty? do
  # 曜日相当の一時変数
  i = 0

  # 土曜日まで、かつ日付が存在している間は出力
  while i <= 6 && days.first do
    # 今日と日付が同じなら反転させる
    if days.first != "" && today == Date.new(year, month, days.first.to_i)
      print "\e[47m" + days.shift.to_s.rjust(DAY_DIGIT) + "\e[0m"
    else
      print days.shift.to_s.rjust(DAY_DIGIT)
    end
    print " " unless i == 6
    i += 1
  end

  # 土曜日まで出力したら改行
  puts
end
# calコマンドは最後に改行を挟む
puts
