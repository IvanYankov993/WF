#!/usr/bin/expect -f
#bassing arguments or executing bash commands in expect script
#https://stackoverflow.com/questions/11131318/how-to-use-bash-script-variables-in-expect-conditional-statements
#set NamePA [lindex $argv 0]
#set NameDNA [lindex $argv 1]
#set ns [lindex $argv 2]
set Complex [lindex $argv 0]
set ns [lindex $argv 1]
set timeout -1
spawn ./corma.in

expect " ENTER input file name: "
#send -- "${Complex}_start.pdb\n"
send -- "${Complex}.pdb\n"
expect " ENTER output file name: "
#send -- "${Complex}_${ns}ns.pdb\n"
send -- "${Complex}_${ns}ns.pdb\n"
expect " IS THE MOLECULE A NUCLEIC ACID? (y/n): "
send -- "y\n"
expect " ISOTROPIC, LOCAL, MODEL-FREE or ANISOTROPIC (iso/loc/mod/ani): "
send -- "iso\n"
expect " ENTER EFFECTIVE ISOTROPIC CORRELATION TIME FOR BASE PROTONS (ns): "
send -- "${ns}\n"
expect " ENTER EFFECTIVE ISOTROPIC CORRELATION TIME FOR SUGAR PROTONS (ns): "
send -- "${ns}\n"
expect " ENTER HEADER FOR OUTPUT FILE:"
send -- "\n"

expect eof
