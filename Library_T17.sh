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





