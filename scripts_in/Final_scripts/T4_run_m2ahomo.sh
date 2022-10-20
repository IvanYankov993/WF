#!/usr/bin/expect -f
#### should be S4 not T4 s stands for expect
#printf "GTAC_iPr.rand\1\ \GTAC_iPr.rest\20\20\1\1\0\0" | ./m2ahomo
set inp [lindex $argv 0]

set timeout -1
spawn ./m2ahomo

expect "input mardigras restraint file :"
send -- "${inp}.rand\n" 
#var

expect "for Mardi output: "
send -- "1\n"			
#Amber namelist outpu, probably wont change

expect "enter <return> if no such a thing) : "
send -- "filter.list\n" 
#try <return> or \n or filter.list where filter.list must exist

expect "enter <return> if no such a thing) : "
send -- "\n" 
#try <return> or \n for the map

expect "output Amber restraint file    : "
send -- "${inp}.rest\n" 
#var as input but use .rest

expect "lower & upper force constants       = "
send -- "20\n"

expect ""
send -- "20\n"

expect "lower & upper widths of the parabolic part = "
send -- "1\n"

expect ""
send -- "1\n"

expect "(enter zero if it is not a homodimer)  = "
send -- "0\n"

expect "how many residues in a monomer = "
send -- "0\n" 
#or smth else try?

expect eof

