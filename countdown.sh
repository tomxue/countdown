#!/bin/bash 
 
if [ "$#" -lt "2" ] ; then 
	echo "Incorrect usage ! Example:" 
	echo './countdown.sh -d  "Jun 10 2011 16:06"' 
	echo 'or' 
	echo './countdown.sh -m  90' 
	exit 1 
fi 
 
now=`date +%s` 
 
if [ "$1" = "-d" ] ; then 
	until=`date -d "$2" +%s` 
	sec_rem=`expr $until - $now` 
	echo "-d" 
	if [ $sec_rem -lt 1 ]; then 
		echo "$2 is already history !" 
	fi 
fi 
 
if [ "$1" = "-m" ] ; then 
	until=`expr 60 \* $2` 
	until=`expr $until + $now` 
	sec_rem=`expr $until - $now` 
	echo "-m" 
	if [ $sec_rem -lt 1 ]; then 
		echo "$2 is already history !" 
	fi 
fi 
 
_R=0
_C=7
tmp=0
percent=0
total_time=0
col=`tput cols`
col=$[ $col -5 ]

while [ $sec_rem -gt 0 ]; do 
	clear 
	date 
	let sec_rem=$sec_rem-1 
	interval=$sec_rem 
	seconds=`expr $interval % 60` 
	interval=`expr $interval - $seconds` 
	minutes=`expr $interval % 3600 / 60` 
	interval=`expr $interval - $minutes` 
	hours=`expr $interval % 86400 / 3600` 
	interval=`expr $interval - $hours` 
	days=`expr $interval % 604800 / 86400` 
	interval=`expr $interval - $hours` 
	weeks=`expr $interval / 604800` 
	echo "----------------------------" 
	echo "Seconds: " $seconds 
	echo "Minutes: " $minutes 
	echo "Hours:   " $hours 
	echo "Days:    " $days 
	echo "Weeks:   " $weeks 

	echo -n "["

	progress=$[$progress + 1]
	if [ $total_time -lt 1 ] ; then
		total_time=$[$hours * 3600 + $minutes * 60 + $seconds]
	fi
	
	printf -v f "%$(echo $_R)s>" ; printf "%s\n" "${f// /=}"
	_C=7
	tput cup 7 $col

	tmp=$percent
	percent=$[$progress * 100 / $total_time]
	printf "]%d%%" $percent
	change=$[$percent - $tmp]

	_R=$[ $col * $percent / 100 ]

	sleep 1
done
printf "\n"
