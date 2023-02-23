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
for ((z=ns_lower_bracket; z<=$ns_count; z++)); do
for i in $listVar; do
	name="${Complex}_${z}ns_${i}"
	cp Template.PARM Template${z}${i}.PARM 
	sed -i "1s/.*/PDB FILE ${Complex}_${z}ns.pdb/" Template${z}${i}.PARM 
	sed -i "2s/.*/INT FILE $i.INT.1/" Template${z}${i}.PARM 
	sed -i "3s/.*/OUT FILE $name/" Template${z}${i}.PARM 
	#the above variable j will be repalced with the DNA_PA (complex) variable when accessible  
	# add a INT.1 Check to extract the e+05 or e+06
	StringVal="e+01 e+02 e+03 e+04 e+05 e+06 e+07 e+08 e+09 e+10 e+11"
	for val in $StringVal; do
	if grep -q $val $i.INT.1; then
	echo "$i.INT.1" $val >> ${WFPATH}/NMR_MD_IY.log # SomeString was found
	sed -i "5s/.*/NOISE ABSOLUTE UNNORMALIZED 1.00$val/" Template${z}${i}.PARM 
	break
	fi
	done
	
	echo "Template${z}${i}.PARM" >> gnu_parallel_mardigras.txt

	#./mardigras Template.PARM 
	#running the mardigras calculations
	if ! command -v man parallel:
	then echo "sequential run"; echo "sequential run" >>${WFPATH}/NMR_MD_IY.log ; ./mardigras Template${z}${i}.PARM; 
	fi
done
done


if command -v man parallel:
then echo "parallel run"; echo "sequential run" >>${WFPATH}/NMR_MD_IY.log ; parallel -a gnu_parallel_mardigras.txt ./mardigras;
fi