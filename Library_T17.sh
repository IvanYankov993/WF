#!/bin/bash
#libraryuntction.sh will collect all the funcitons I might need.


######################################################################
#              ########                                              #
#                 #                                                  #
#                 #                                                  #
#                 #                                                  #
#                 #                                                  #
######################################################################

#Make a tree directory for DNA_PA/runN 
worktree () {
#Create int current directory root/branch/tweeg based on WFPATH/DNA_PA/RunN
#                                                           WFPATH/DP/RunN
cd ${WFPATH}
DP="${NameDNA}_${NamePA}"
if [ -d "$DP" ]; then
    echo "$DP is a directory."
else
    mkdir ${DP}
fi

for i in $(seq 0 ${runN})
do
    cd "${WFPATH}/${DP}"
    FILE1="Run_${i}"
    if [ -d "$FILE1" ]; then
        echo "$FILE1 is a directory."
    else
        mkdir ${FILE1}
        cd ${FILE1}
        mkdir MDprep Mardi
    fi
done
cd ${WFPATH}
export DP
}


# consider doing T_1 - (PA_DNACOMPLEXFOLDER)structure, topology, rst, mol2, forcmod, 
#tleap solvation protolcand others cpptraj clustering
#cpptraj protocols - clustering anlysis
#MD simulaiton protocls .in files


#select_5 # select_5 needs to be in the same directroy
    #no input
    # returnes 5 variables numbers between 1-20 for where 20 is j in clustering.cpptraj.in 


select_5 () {
> distance_penalties.txt
> sorted.txt
> var_list.txt
grep "Total distance penalty" s*_anneal_1000K.out >> distance_penalties.txt
#cat distance_penalties.txt | tr -d "[:blank:]"
awk '{print $5, $1}' distance_penalties.txt | sort -n > sorted.txt
awk '{print $2}' sorted.txt > sorted_2.txt
awk -F"_" '{print $1}' sorted_2.txt > sorted_3.txt

arr0=(1,2,3,4,5)
ar_el=0
for el in $(seq 1 5) 
do 
  arr0[$ar_el]=$(sed -n ${el}p sorted_3.txt)
  #arr0+=( $a )
  #echo $a
  echo "${arr0[@]}"
  ar_el=$((ar_el+1))
done
echo "IY CHECK ${arr0[@]}"


}

#########################################################################################
# Get var_list
# cd to new directory for production and annalysis 
# bring cp last frame of var_list
# production run with minisationa dna analysis
#
#########################################################################################



mardigras_calculations () {

#here we need to calculate the final restrains write wait untill they are available
	################## 

    # Move into the Mardi working directory + define the path to move files later
    # Mardigras requires the binaries and input files to be in one directory
    
    # First move all binaries, expect scripts and bash scripts relevant to the WF to 
    # working direcotry in this case Run0/Mardi
    
    cd "${WFPATH}/${DP}/Run_0/Mardi"
	c1wd=$(pwd)
    cp $var_path* $c1wd

    # move Mardigras relevant files from the inp directory and source directoryto c1wd

	cp "${inp}${DP}_corma.pdb" $c1wd
	cp ${inp}*.INT.1 $c1wd
	cp "${inp}pseudo.inp" $c1wd
	cp "${inp}filter.list" $c1wd 
	cp "${scr}run.sh" $c1wd
    cp "${inp}wc.txt" $c1wd

    echo $c1wd $(ls) >> ${WFPATH}/NMR_MD_IY.log

    # Mardigras calculations
    # ./run_mardigra.sh
    ./T1_run_corma.sh << EOF
    ${DP}_corma
    1
    2
EOF
   
    #### https://unix.stackexchange.com/questions/288765/using-a-bash-script-to-run-an-interactive-program
    ###EOF statements
    rm  $files

    #Take removed restraints and filter out or add WC restraints at the bottom which will be available from the inp files WC.rest
	cat wc.txt >> "${DP}_corma.rest"

	################## restrained Annealing + Select 5 ##################

	cd "${WFPATH}/${DP}/Run_0/MDprep"
	cwd=$(pwd)
	cp "${c1wd}/${DP}_corma.rest" $cwd
    cd ${WFPATH}






}



