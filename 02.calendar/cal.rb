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
p params
