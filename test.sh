#!/bin/bash
exec 1>~/debug.out
exec 3>~/time.out
#export PGWAdd=10.223.75.150
#
# function to subtool
#
function ph1 {
subtool ZMHHVLR-BATCH28 8613440215 8613440216 8613440261 8613440262 8613441223 8613441224 8613442253 8613442254 8613443213 8613443269 8613444204 8613444251 8613445217 8613445218 8613740295 8613740296 8613740297 8613741270 8613743228 8613745223 8613745301 8613746220 8613747256 8613747257 8613748270 8613748271 8613749297 8613749302 
}
#
function ph2 {
subtool ZMHHVLR-RANGE2 819000000000000 819099999999999 819000000000 819099999999
}
#
function ph3 {
subtool ZMHHVLR-RANGE3 618100000000 628199999999 62810000000 62819999999 62890000000000 62899999999999
}
#
function ph4 {
subtool ZMHHVLR-RANGE 639100000000 639199999999
}
#
function ph5 {
subtool ZMHHVLR-RANGE 886900000000 886999999999
}
#
#create time to file time.out
#
echo "[ Begin execute first subtool for time ]: `date "+%F %T"`" >&3
#
ph1
#
echo "[ Finish execute first subtool for time ]: `date "+%F %T"`" >&3
echo   >&3
#
echo "[ Begin execute second subtool for time ]: `date "+%F %T"`" >&3
#
ph2
#
echo "[ Finish execute second subtool for time ]: `date "+%F %T"`" >&3
echo   >&3
#
echo "[ Begin execute third subtool for time ]: `date "+%F %T"`" >&3
#
ph3
#
echo "[ Finish execute third subtool for time ]: `date "+%F %T"`" >&3
echo   >&3
#
echo "[ Begin execute forth subtool for time ]: `date "+%F %T"`" >&3
#
ph4
#
echo "[ Finish execute forth subtool for time ]: `date "+%F %T"`" >&3
echo   >&3
#
echo "[ Begin execute fifth subtool for time ]: `date "+%F %T"`" >&3
#
ph5
#
echo "[ Finish execute fifth subtool for time ]: `date "+%F %T"`" >&3
echo   >&3
