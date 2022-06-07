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

p params
