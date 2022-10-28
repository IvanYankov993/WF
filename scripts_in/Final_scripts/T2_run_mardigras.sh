#!/bin/bash
listVar=`basename -s .INT.1 *.INT.1`
listVar2=`basename -s .pdb *ns.pdb`
#https://unix.stackexchange.com/questions/138634/shortest-way-to-extract-last-3-characters-of-base-minus-suffix-filename
#https://www.tecmint.com/assign-linux-command-output-to-variable/
#echo $listVar
#echo $listVar2
#how to edit the enabled run_rand_restr.sh file having expect
#https://stackoverflow.com/questions/11145270/how-to-replace-an-entire-line-in-a-text-file-by-line-number

#run mardigras in a loop, for each pdb do, for each combo do prep an PARM FILE, run mardigras Repeat, repeat,

##################################
#	Introduce parallel here. first create .Parm file with sep names
#	execute run paralel with file input unique PARM names and command mardigras.
#	each .Parm file is for each Int.1 for each ns corr time.
#	givng a total of corr time X INT.1.
#	Add a wait before running T3
################################
#complex substituted listvar2 because there will be one to many pdbs. 
#for j in $Complex; do
> gnu_parallel_mardigras.txt
for ((z=1; z<=$ns_count; z++)); do
echo $z	
for i in $listVar; do
	name="${Complex}_${z}ns_${i}"
	echo $name
	#echo $i
	#echo "$j Text is it new line $z"
	cp Template.PARM Template${z}${i}.PARM 
	sed -i "1s/.*/PDB FILE ${Complex}_${z}ns.pdb/" Template${z}${i}.PARM 
	sed -i "2s/.*/INT FILE $i.INT.1/" Template${z}${i}.PARM 
	sed -i "3s/.*/OUT FILE $name/" Template${z}${i}.PARM 
#the above variable j will be repalced with the DNA_PA (complex) variable when accessible  
	sed -i "5s/.*/NOISE ABSOLUTE UNNORMALIZED 1.00e+06/" Template${z}${i}.PARM 
#NB the 1.00e+06 must be extracted from the lowest intensity peak in the peak list file
	echo $j
	echo $i
	echo "Template${z}${i}.PARM" >> gnu_parallel_mardigras.txt
	#./mardigras Template.PARM
	if ! command -v man parallel:
	then echo "sequential run"; ./mardigras Template${z}${i}.PARM; 
	fi
done
done
#done
if command -v man parallel:
then echo "parallel run"; parallel -a gnu_parallel_mardigras.txt ./mardigras;
fi













#for ((z=1; z<=$ns_count; z++)); do
#echo $z	
#for i in $listVar; do
#	name="${Complex}_${z}ns_${i}"
#	echo $name
#	#echo $i
#	#echo "$j Text is it new line $z"
#	sed -i "1s/.*/PDB FILE ${Complex}_${z}ns.pdb/" Template.PARM 
#	sed -i "2s/.*/INT FILE $i.INT.1/" Template.PARM
#	sed -i "3s/.*/OUT FILE $name/" Template.PARM
##the above variable j will be repalced with the DNA_PA (complex) variable when accessible  
#	sed -i "5s/.*/NOISE ABSOLUTE UNNORMALIZED 1.00e+06/" Template.PARM 
##NB the 1.00e+06 must be extracted from the lowest intensity peak in the peak list file
#	echo $j
#	echo $i
#	./mardigras Template.PARM
#done
#done
