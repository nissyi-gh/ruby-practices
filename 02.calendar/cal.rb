require 'date'
require 'optparse'

# OptionParserオブジェクトを生成
opt = OptionParser.new
# 取り扱うOptionを設定
opt.on('-m')
opt.on('-y')
# ハッシュに引数を格納する
params = ARGV.getopts("y:m:")
# p params
