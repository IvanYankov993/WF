#!/bin/bash
listVar=`basename -s .OUT *.OUT`
#https://www.tecmint.com/assign-linux-command-output-to-variable/
#echo $listVar

#how to edit the enabled run_rand_restr.sh file having expect
#https://stackoverflow.com/questions/11145270/how-to-replace-an-entire-line-in-a-text-file-by-line-number
mkdir old_rand
mv *.rand old_rand 
mv *.rest old_rand 
sed -i '22,$ d' S3_run_rand_restr_expect.sh 
mix=0
for i in $listVar; do
    ((mix=mix+1))
    echo 'expect "mixing time "' >> S3_run_rand_restr_expect.sh 
    echo send -- '"'"${i}\n"'"' >> S3_run_rand_restr_expect.sh 
	
done

echo 'expect "% of distances "' >> S3_run_rand_restr_expect.sh 
echo send -- '"'"10\n"'"' >> S3_run_rand_restr_expect.sh 

echo 'expect "output file for "' >> S3_run_rand_restr_expect.sh 
echo send -- '"${out}.rand\n"' >> S3_run_rand_restr_expect.sh
#if .rand file exist in directory we will recieve fortran runtime error, might be a good idea to delete all .rand file before running this code 
echo expect eof >> S3_run_rand_restr_expect.sh

echo ${mix}
./S3_run_rand_restr_expect.sh ${mix} ${Complex}





