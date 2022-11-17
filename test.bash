#!/bin/bash
echo -n > rapport
for i in test/*
do	
	cat $i | ./src/as
	echo $i: $? >> rapport
done
