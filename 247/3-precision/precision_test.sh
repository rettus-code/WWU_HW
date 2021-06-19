#!/usr/bin/env bash
#
cat precision_test.dat | tr ',' ' ' | while read a b c
do 
    if [ "$c" != "$(./precision_test "$a" "$b")" ]
    then 
        echo "FAIL: expected $c but got \"$(./precision_test $a $b)\" for $a + $b"
        exit 1 
    fi;
done

