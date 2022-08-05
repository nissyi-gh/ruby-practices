#!/bin/sh
function result_check() {
  echo "expect: $1"
  echo "result: $2"
  if [ $1 -eq $2 ]
  then
    echo "******* 結果は同じです *******"
  else
    echo "結果が違います"
  fi

  echo "-------"
}

command="./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5"
echo "command: ${command}"
result=`ruby ${command}`
expect=139
result_check ${expect} ${result}

command="./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X"
echo "command: ${command}"
result=`ruby ${command}`
expect=164
result_check ${expect} ${result}

command="./bowling.rb 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4"
echo "command: ${command}"
result=`ruby ${command}`
expect=107
result_check ${expect} ${result}

command="./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0"
echo "command: ${command}"
result=`ruby ${command}`
expect=134
result_check ${expect} ${result}

command="./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8"
echo "command: ${command}"
result=`ruby ${command}`
expect=144
result_check ${expect} ${result}

command="./bowling.rb X,X,X,X,X,X,X,X,X,X,X,X"
echo "command: ${command}"
result=`ruby ${command}`
expect=300
result_check ${expect} ${result}
