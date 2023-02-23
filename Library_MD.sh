#!/bin/bash
#libraryuntction.sh will collect all the funcitons I might need.

######################################################################
#                 #       # ####        ##### # #       #            #
#                 ##     ## #   #      #      # ##     ##            #
#                 # #   # # #    #      ####  # # #   # #            #
#                 #  # #  # #   #           # # #  # #  #            #
#                 #   #   # ####       #####  # #   #   #            #
######################################################################


min12md12 () {

#############change ncrst formats to nc
############ -x saves trajectoreis do we want all of them or not? or just out files
echo ${AmberRun}
[[ -f ${DP}_solv.rst7 && ! -f ${DP}_solv_min1.ncrst ]] && ${AmberRun} -O -i ${scr}dna_min1.in -o ${DP}_solv_min1.out -c ${DP}_solv.rst7 -p ${DP}_solv.prmtop -r ${DP}_solv_min1.ncrst -ref ${DP}_solv.rst7

[[ -f ${DP}_solv_min1.ncrst && ! -f ${DP}_solv_min2.ncrst ]] && ${AmberRun} -O -i ${scr}dna_min2.in -o ${DP}_solv_min2.out -c ${DP}_solv_min1.ncrst -p ${DP}_solv.prmtop -r ${DP}_solv_min2.ncrst

[[ -f ${DP}_solv_min2.ncrst && ! -f ${DP}_solv_md1.ncrst ]] && ${AmberRun} -O -i ${scr}dna_md1.in -o ${DP}_solv_md1.out -c ${DP}_solv_min2.ncrst -p ${DP}_solv.prmtop -r ${DP}_solv_md1.ncrst -ref ${DP}_solv_min2.ncrst

[[ -f ${DP}_solv_md1.ncrst && ! -f ${DP}_solv_md2.ncrst ]] && ${AmberRun} -O -i ${scr}dna_md2.in -o ${DP}_solv_md2.out -c ${DP}_solv_md1.ncrst -p ${DP}_solv.prmtop -r ${DP}_solv_md2.ncrst -x ${DP}_solv_md2.nc
}

### maybe add out analysis

annealMDrest () {
     ##### run the echo > fil.txt file and consecutive loop without execution.

     #before running pmem.cuda cuda.in must append the last line giving path/restraints file with var name
     sed -i '$d' ${scr}anneal_1000K_cuda.in
     echo "DISANG=${cwd}/${DP}_corma.rest" >> ${scr}anneal_1000K_cuda.in
     # the above ${cwd}/${DP}_wc_flip.rest"wc.flp.rest will benefit from automated handling proceedure for allowing WC restraitns only on thelast basepairs
     echo > fil.txt
     for i in {1..20}
     do
     #j=$((1+${i})) when i in {0..19}
     #FILE=s${j}_anneal_1000K.out
     #######can run this with parallel -a fil.txt (file.txt has all lines in the for loop rpinted and allows parallel to run simultaneously)
     #if [ ! -f "$FILE" ]; then
          #echo ${AmberRun} -O -i ${scr}anneal_1000K_cuda.in -c s${j}_anneal_start.rst7 -p anneal.prmtop -o s${j}_anneal_1000K.out -r s${j}_anneal_1000K_flip.ncrst -x s${j}_anneal_1000K_flip.nc >> fil.txt
          
          ${AmberRun} -O -i ${scr}anneal_1000K_cuda.in -c s${i}_anneal_start.rst7 -p anneal.prmtop -o s${i}_anneal_1000K.out -r s${i}_anneal_1000K_flip.ncrst -x s${i}_anneal_1000K_flip.nc
          #we can remove the trajectory as it takes space and we are not interested in it
     #fi
     
     done
     #for i in {1..20}; do scr="/home/gabnmr/Documents/NMR_M_R/scripts_in/"; ${AmberRun} -O -i ${scr}anneal_1000K_cuda.in -c s${i}_anneal_start.rst7 -p anneal.prmtop -o s${i}_anneal_1000K.out -r s${i}_anneal_1000K_flip.ncrst -x s${i}_anneal_1000K_flip.nc; done
     ################## the above path must be scr or wfpath/scripts_in/
     #parallel -a fil.txt 
}



#run production of 5 ns
run_5ns_prod () {
cwd2=$(pwd)
cp ${scr}dna_md4.in $cwd2
j=-1
  for i in {0..4}
  do
    j=$((1+${j}))
    echo ${j}
    var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
    #| awk -F"s" '{print $0}'
    echo ${var_selected}
    FILE=${var_selected}
    FILE=${arr0[${j}]}
    
    #should be solvent minimisation
    ${AmberRun} -O -i ${scr}dna_min1.in -p ${FILE}_anneal_solv.prmtop -o ${FILE}_anneal_solv_min1.out -c ${FILE}_anneal_solv_flip.rst7 -r ${FILE}_anneal_solv_min1_flip.ncrst -ref ${FILE}_anneal_solv_flip.rst7
    
    #should be heating up
    ${AmberRun} -O -i ${scr}dna_md1.in -p ${FILE}_anneal_solv.prmtop -o ${FILE}_anneal_solv_md1.out -c ${FILE}_anneal_solv_min1_flip.ncrst -r ${FILE}_anneal_solv_md1_flip.ncrst -ref ${FILE}_anneal_solv_flip.rst7
    
    #equilibration
    #sed -i '$d' ${scr}dna_md2.in
    #echo "DISANG=${cwd}/${DP}_corma.rest" >> ${scr}dna_md2.in
    ${AmberRun} -O -i ${scr}dna_md2.in -p ${FILE}_anneal_solv.prmtop -o ${FILE}_anneal_solv_md2.out -c ${FILE}_anneal_solv_md1_flip.ncrst -r ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_anneal_solv_md2_flip.nc
    
    #production of 5ns - modify protocol to 5ns
    echo  "FILE var ${FILE}"
      
    # sed -i '$d' ${scr}dna_md4.in
    # echo "DISANG=${cwd}/${DP}_corma.rest" >> ${scr}dna_md4.in
    # ${AmberRun} -O -i ${scr}dna_md4.in -o ${FILE}_prod_1ns_flip.out -p ${FILE}_anneal_solv.prmtop -r ${FILE}_prod_1ns_flip.ncrst -c ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_prod_1ns_flip.mdcrd
    
    sed -i '$d' dna_md4.in
    echo "DISANG=${DP}_corma.rest" >> dna_md4.in
    ${AmberRun} -O -i dna_md4.in -o ${FILE}_prod_1ns_flip.out -p ${FILE}_anneal_solv.prmtop -r ${FILE}_prod_1ns_flip.ncrst -c ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_prod_1ns_flip.mdcrd
    
    
    
    #production of 5ns - unrestraiendmd protocol to 5ns (switch off the restraines)
#     ${AmberRun} -O -i dna_md4_unrest.in -o ${FILE}_prod_1ns_flip_unrest.out -p ${FILE}_anneal_solv.prmtop -r ${FILE}_prod_1ns_flip_unrest.ncrst -c ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_prod_1ns_flip_unrest.mdcrd

done
}

run_5ns_unrest_prod () {
j=-1
  for i in {0..4}
  do
    j=$((1+${j}))
    echo ${j}
    var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
    #| awk -F"s" '{print $0}'
    echo ${var_selected}
    FILE=${var_selected}
    FILE=${arr0[${j}]}
    #should be solvent minimisation
#     ${AmberRun} -O -i ${scr}dna_min1.in -p ${FILE}_anneal_solv.prmtop -o ${FILE}_anneal_solv_min1.out -c ${FILE}_anneal_solv_flip.rst7 -r ${FILE}_anneal_solv_min1_flip.ncrst -ref ${FILE}_anneal_solv_flip.rst7
    #should be heating up
#     ${AmberRun} -O -i ${scr}dna_md1.in -p ${FILE}_anneal_solv.prmtop -o ${FILE}_anneal_solv_md1.out -c ${FILE}_anneal_solv_min1_flip.ncrst -r ${FILE}_anneal_solv_md1_flip.ncrst -ref ${FILE}_anneal_solv_flip.rst7
    #equilibration
    #sed -i '$d' ${scr}dna_md2.in
    #echo "DISANG=${cwd}/${DP}_corma.rest" >> ${scr}dna_md2.in
#     ${AmberRun} -O -i ${scr}dna_md2.in -p ${FILE}_anneal_solv.prmtop -o ${FILE}_anneal_solv_md2.out -c ${FILE}_anneal_solv_md1_flip.ncrst -r ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_anneal_solv_md2_flip.nc
    
    #production of 5ns - modify protocol to 5ns
    echo  "FILE var ${FILE}"
#     sed -i '$d' ${scr}dna_md4.in
#     echo "DISANG=${cwd}/${DP}_corma.rest" >> ${scr}dna_md4.in
#     ${AmberRun} -O -i ${scr}dna_md4.in -o ${FILE}_prod_1ns_flip.out -p ${FILE}_anneal_solv.prmtop -r ${FILE}_prod_1ns_flip.ncrst -c ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_prod_1ns_flip.mdcrd
    #production of 5ns - unrestraiendmd protocol to 5ns (switch off the restraines)
    ${AmberRun} -O -i ${scr}dna_md4_unrest.in -o ${FILE}_prod_1ns_flip_unrest.out -p ${FILE}_anneal_solv.prmtop -r ${FILE}_prod_1ns_flip_unrest.ncrst -c ${FILE}_anneal_solv_md2_flip.ncrst -x ${FILE}_prod_1ns_flip_unrest.mdcrd


     # to run using parallel generate each min 1 md1 md 2 md4 into a seperate file.txt 
     # then run with parallel -a- file1.txt sander (1) min 1
     # parallel -a file2.txt pmemd.cude (2) md 1 etc
done
}

md_fin_str () {
     
     j=-1
     for i in {0..4}
     do
     j=$((1+${j}))
     echo ${j}
     var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
     var_selected=${var_selected//$'\n'/}
     FILE=${var_selected}
     FILE=${arr0[${j}]}
     echo ${scr}${var_selected}
     #minimisation  
     ${AmberRun} -O -i ${scr}dna_min3.in -c ${FILE}c1_ion_solv.rst7 -p ${FILE}c1_ion_solv.prmtop -o ${FILE}c1_min3.out -r ${FILE}c1_min3.ncrst -ref ${FILE}c1_ion_solv.rst7
     ${AmberRun} -O -i ${scr}dna_min4.in -c ${FILE}c1_min3.ncrst -p ${FILE}c1_ion_solv.prmtop -o ${FILE}c1_min4.out -r ${FILE}c1_min4.ncrst
     ${AmberRun} -O -i ${scr}dna_min3.in -c ${FILE}c2_ion_solv.rst7 -p ${FILE}c2_ion_solv.prmtop -o ${FILE}c2_min3.out -r ${FILE}c2_min3.ncrst -ref ${FILE}c2_ion_solv.rst7
     ${AmberRun} -O -i ${scr}dna_min4.in -c ${FILE}c2_min3.ncrst -p ${FILE}c2_ion_solv.prmtop -o ${FILE}c2_min4.out -r ${FILE}c2_min4.ncrst
     #final pdb
     ambpdb -p ${FILE}c1_ion_solv.prmtop -c ${FILE}c1_min4.ncrst > ${FILE}c1_final.pdb
     ambpdb -p ${FILE}c2_ion_solv.prmtop -c ${FILE}c2_min4.ncrst > ${FILE}c2_final.pdb
     #strip waters and ions
     
     grep -v 'WAT' ${FILE}c1_final.pdb > ${FILE}c1_final_corma.pdb
     sed -i '/Na+/d' ${FILE}c1_final_corma.pdb
     done
}

md_fin_str_unrest () {
     
     j=-1
     for i in {0..4}
     do
     j=$((1+${j}))
     echo ${j}
     var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
     var_selected=${var_selected//$'\n'/}
     FILE=${var_selected}
     FILE=${arr0[${j}]}
     echo ${scr}${var_selected}
     #minimisation  
     ${AmberRun} -O -i ${scr}dna_min3.in -c ${FILE}c1_ion_solv.rst7 -p ${FILE}c1_ion_solv.prmtop -o ${FILE}c1_min3_unrest.out -r ${FILE}c1_min3_unrest.ncrst -ref ${FILE}c1_ion_solv.rst7
     ${AmberRun} -O -i ${scr}dna_min4.in -c ${FILE}c1_min3_unrest.ncrst -p ${FILE}c1_ion_solv.prmtop -o ${FILE}c1_min4_unrest.out -r ${FILE}c1_min4_unrest.ncrst
     ${AmberRun} -O -i ${scr}dna_min3.in -c ${FILE}c2_ion_solv.rst7 -p ${FILE}c2_ion_solv.prmtop -o ${FILE}c2_min3_unrest.out -r ${FILE}c2_min3_unrest.ncrst -ref ${FILE}c2_ion_solv.rst7
     ${AmberRun} -O -i ${scr}dna_min4.in -c ${FILE}c2_min3_unrest.ncrst -p ${FILE}c2_ion_solv.prmtop -o ${FILE}c2_min4_unrest.out -r ${FILE}c2_min4_unrest.ncrst
     #final pdb
     ambpdb -p ${FILE}c1_ion_solv.prmtop -c ${FILE}c1_min4_unrest.ncrst > ${FILE}c1_final_unrest.pdb
     ambpdb -p ${FILE}c2_ion_solv.prmtop -c ${FILE}c2_min4_unrest.ncrst > ${FILE}c2_final_unrest.pdb
     #strip waters and ions
     
     grep -v 'WAT' ${FILE}c1_final_unrest.pdb > ${FILE}c1_final_corma_unrest.pdb
     sed -i '/Na+/d' ${FILE}c1_final_corma_unrest.pdb
     done
}

min12md12_loop () {

#############change ncrst formats to nc
############ -x saves trajectoreis do we want all of them or not? or just out files
${AmberRun} -O -i ${scr}dna_min1.in -o ${DP}_solv_min1.out -c ${FILE}c1_min4.ncrst -p ${FILE}c1_ion_solv.prmtop -r ${DP}_solv_min1.ncrst -ref ${FILE}c1_min4.ncrst 
#[[ -f ${FILE}c1_min4.ncrst && ! -f ${DP}_solv_min1.ncrst ]] && ${AmberRun} -O -i ${scr}dna_min1.in -o ${DP}_solv_min1.out -c ${DP}_solv.rst7 -p ${DP}_solv.prmtop -r ${DP}_solv_min1.ncrst -ref ${DP}_solv.rst7
${AmberRun} -O -i ${scr}dna_min2.in -o ${DP}_solv_min2.out -c ${DP}_solv_min1.ncrst -p ${FILE}c1_ion_solv.prmtop -r ${DP}_solv_min2.ncrst
#[[ -f ${DP}_solv_min1.ncrst && ! -f ${DP}_solv_min2.ncrst ]] && ${AmberRun} -O -i ${scr}dna_min2.in -o ${DP}_solv_min2.out -c ${DP}_solv_min1.ncrst -p ${DP}_solv.prmtop -r ${DP}_solv_min2.ncrst
${AmberRun} -O -i ${scr}dna_md1.in -o ${DP}_solv_md1.out -c ${DP}_solv_min2.ncrst -p ${FILE}c1_ion_solv.prmtop -r ${DP}_solv_md1.ncrst -ref ${DP}_solv_min2.ncrst
#[[ -f ${DP}_solv_min2.ncrst && ! -f ${DP}_solv_md1.ncrst ]] && ${AmberRun} -O -i ${scr}dna_md1.in -o ${DP}_solv_md1.out -c ${DP}_solv_min2.ncrst -p ${DP}_solv.prmtop -r ${DP}_solv_md1.ncrst -ref ${DP}_solv_min2.ncrst
${AmberRun} -O -i ${scr}dna_md2.in -o ${DP}_solv_md2.out -c ${DP}_solv_md1.ncrst -p ${FILE}c1_ion_solv.prmtop -r ${DP}_solv_md2.ncrst -x ${DP}_solv_md2.nc
#[[ -f ${DP}_solv_md1.ncrst && ! -f ${DP}_solv_md2.ncrst ]] && ${AmberRun} -O -i ${scr}dna_md2.in -o ${DP}_solv_md2.out -c ${DP}_solv_md1.ncrst -p ${DP}_solv.prmtop -r ${DP}_solv_md2.ncrst -x ${DP}_solv_md2.nc
}