#!/bin/bash

# export and import zset key

function zset_1() {
for i in `cat zset_key.txt`
do
    redis-cli -p 6379 SCAN 0 match "$i" count 99999 |grep "aol" >key_zset
    if [ -f key_zset ]; then
        for i in `cat key_zset`
        do 
            redis-cli -p 6379 --csv  ZRANGE $i 0 -1 withscores >aol_zset_redis.csv
            if [ -f aol_zset_redis.csv ]; then
                #cat  aol_redis.csv |sed  's/,/\n/g' |sed 'N;s/\n/ /' |sed ':a; N;s/\n/ /; t a' >once_redis.csv
                cat  aol_zset_redis.csv |sed  's/,/\n/g' |sed 'N;s/\n/ /' |awk '{print $2,$1}' >zset_redis.csv
            fi
            sed -i "s/^\(\".*\"$\)/ZADD $i \1/" zset_redis.csv
            redis-cli -p 6379 -h 10.36.192.162 < zset_redis.csv
        done
    else
        echo "error,no keys found."
    fi
done
}
        
# export and import set key

function set_1() {
for i in `cat set_key.txt`
do
    redis-cli -p 6379 SCAN 0 match "$i" count 99999 |grep "check" >key_set
    if [ -f key_set ]; then
        for i in `cat key_set`
        do 
            redis-cli -p 6379 --csv SMEMBERS $i >aol_set_redis.csv
            if [ -f aol_set_redis.csv ]; then
                #cat  aol_redis.csv |sed  's/,/\n/g' |sed 'N;s/\n/ /' |sed ':a; N;s/\n/ /; t a' >once_redis.csv
                cat  aol_set_redis.csv  >set_redis.csv
            fi
            sed -i "s/^\(\".*\"$\)/SADD $i \1/" set_redis.csv
            redis-cli -p 6379 -h 10.36.192.162 < set_redis.csv
        done
    else
        echo "error,no keys found."
    fi
done
}
        

# export and import hash key

function hash_1() {
for i in `cat hash_key.txt`
do
    redis-cli -p 6379 SCAN 0 match "$i" count 99999 |grep "aol" >key_hash
    if [ -f key_hash ]; then
        for i in `cat key_hash`
        do 
            redis-cli -p 6379 --csv hgetall $i >aol_hash_redis.csv
            if [ -f aol_hash_redis.csv ]; then
                cat  aol_hash_redis.csv |sed  's/,/\n/g' |sed 'N;s/\n/ /' |sed ':a; N;s/\n/ /; t a' >hash_redis.csv
            fi
            sed -i "s/^\(\".*\"$\)/HMSET $i \1/" hash_redis.csv
            redis-cli -p 6379 -h 10.36.192.162 < hash_redis.csv
        done
    else
        echo "error,no keys found."
    fi
done
}
        

# main function 
function main() {
zset_1
set_1
hash_1
}

main
