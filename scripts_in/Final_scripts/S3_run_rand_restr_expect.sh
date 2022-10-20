#!/usr/bin/expect -f
#bassing arguments or executing bash commands in expect script
#https://askubuntu.com/questions/689001/using-bash-commands-in-expect-script
set mix [lindex $argv 0]
set out [lindex $argv 1]
set timeout -1
spawn ./rand-restr
expect "number of mixing times = "
send -- "${mix}\n" 
#var 1,2,3 ns * H2O 250 ms D2O 250 200 150 100 ms
# var can reach 8 * 5  = 40
expect "number of rundom runs  = "
send -- "10\n"			
#A stays constant and must be same as the one in MARDIGRAS
#listVar="1 2 3"
#for i in $listVar; do
#    expect "mixing time "
#    send -- "$i\n" 
#done
#Build the list using liastVar = ls *.bnds or *.out only the * and use the for loop
#solution https://linuxhint.com/read_filename_without_extension_bash/
expect "mixing time "
send -- "GTAC_iPr_corma_1ns\n"
expect "% of distances "
send -- "10\n"
expect "output file for "
send -- "${out}.rand\n"
expect eof
