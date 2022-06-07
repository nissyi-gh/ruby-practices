require 'date'
require 'optparse'

# 本日の指定、比較用にDateオブジェクトを生成
today = Date.today
# OptionParserオブジェクトを生成
opt = OptionParser.new
# 取り扱うOptionを設定
opt.on('-m')
opt.on('-y')
# ハッシュに引数を格納する
params = ARGV.getopts("", "y:#{today.year}", "m:#{today.month}")

# オプションの年を検証して、無効ならエラー文を表示する
def validation_of_year(year)
  puts "Invalid year." unless year >= 1 && year <= 9999
end

# オプションの月を検証して、無効ならエラー文を表示する
def validation_of_month(month)
  puts "Invalid month." unless month >= 1 && month <= 12
end

validation_of_year(params["y"] = params["y"].to_i)
validation_of_month(params["m"] = params["m"].to_i)

# 指定した年月の日付配列を返す
def return_days_array_of_month(year, month)
  last_day = Date.new(year, month, -1).day
  (1..last_day).map(&:to_i)
end

days = return_days_array_of_month(params["y"], params["m"])

CALENDER_WIDTH = 20
puts "#{params["m"]}月 #{params["y"]}".center(CALENDER_WIDTH)

puts DAY_OF_WEEK = "日 月 火 水 木 金 土"


# 月初の曜日を特定する
start_day_of_week = Date.new(params["y"], params["m"], 1).wday
i = start_day_of_week
# days配列の要素が存在する限りループ
until days.empty? do
  # 土曜日まで、かつ日付が存在している間は出力
  while i <= 6 && days.first do
    print i == 0 ? days.shift.to_s.rjust(2) : days.shift.to_s.rjust(3)
    i += 1
  end
  puts
  i = 0
end
