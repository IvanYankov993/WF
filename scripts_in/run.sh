#!/bin/bash
cwd=$(pwd)
echo $cwd
var_path="${scr}Final_scripts/"
#var_path=/home/gabnmr/Documents/ivan/Practice_scipts/Integrated_Spary_Chimera_Mardigras/Final_scripts/
cd $var_path
files=$(ls)
cd $cwd
echo $files
cp $var_path* $cwd
ls
./T1_run_corma.sh <<EOF
${DP}_corma
2
EOF
#### https://unix.stackexchange.com/questions/288765/using-a-bash-script-to-run-an-interactive-program
###EOF statements
rm  $files

#Take removed restraints and filter out or add WC restraints at the bottom which will be available from the inp files WC.rest
