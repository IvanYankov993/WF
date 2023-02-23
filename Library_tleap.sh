#!/bin/bash
#libraryuntction.sh will collect all the funcitons I might need.

######################################################################
#              ########  #       #######      #      ###             #
#                 #      #       #           # #     #  #            #
#                 #      #       #######    #   #    ###             #
#                 #      #       #         #######   #               #
#                 #      ####### #######  #       #  #               #
######################################################################


tleap_start () {
    # ask for the tleap script - solvatin, lib and frcmod or cluster rst7 and solvating and rst7
    x=tleap_script.in
    echo source leaprc.gaff > tleap_script.in
    echo source leaprc.DNA.bsc1 >> tleap_script.in
    echo source leaprc.water.tip3p >> tleap_script.in
    echo loadamberparams ${inp}${NamePA_PA}.frcmod >> tleap_script.in
    echo loadoff ${inp}${NamePA_PA}.lib >> tleap_script.in
}

tleap_start_freeDNA () {
    # ask for the tleap script - solvatin, lib and frcmod or cluster rst7 and solvating and rst7
    x=tleap_script.in
    echo source leaprc.gaff > tleap_script.in
    echo source leaprc.DNA.bsc1 >> tleap_script.in
    echo source leaprc.water.tip3p >> tleap_script.in
}


tleap_conf () {
    #tleap_start
    #requires inp for start pdb and DP shorthand for DNA_PA
    echo complex = loadpdb ${inp}${DP}_start.pdb >> tleap_script.in
    echo check complex >> tleap_script.in
    echo saveamberparm complex ${DP}.frcmod ${DP}.rst7 >> tleap_script.in
    echo saveamberparm complex ${DP}.prmtop ${DP}.rst7 >> tleap_script.in
    echo addions complex Na+ 0 >> tleap_script.in
    echo check complex >> tleap_script.in
    echo saveamberparm complex ${DP}_neu.frcmod ${DP}_neu.rst7 >> tleap_script.in
    echo saveamberparm complex ${DP}_neu.prmtop ${DP}_neu.rst7 >> tleap_script.in
    #this solvateoct complex size 12.0 but requires longer minimisation 1 and 2
    echo solvatebox complex TIP3PBOX 10.0 >> tleap_script.in
    echo check complex >> tleap_script.in
    echo saveamberparm complex ${DP}_solv.frcmod ${DP}_solv.rst7 >> tleap_script.in
    echo saveamberparm complex ${DP}_solv.prmtop ${DP}_solv.rst7 >> tleap_script.in
    echo quit >> tleap_script.in
    tleap -f tleap_script.in
}

tleap_anneal_rst7 () {
  #tleap_start
  ###################maybe request that the j variable after the clustering is exported so its available here
  for i in {0..19}
  do
  j=$((1+${i}))
  #file2=s${j}_anneal_start.rst7
  #if [ ! -f "${file2}" ]; then
  #  FILE=s${j}.pdb
  #  if [ -f "$FILE" ]; then
        echo complex${j} = loadpdb s${j}.pdb >> tleap_script.in
        echo check complex${j} >> tleap_script.in
        echo saveamberparm complex${j} anneal.prmtop s${j}_anneal_start.rst7 >> tleap_script.in
  #  fi
  #fi
  done
  echo quit >> tleap_script.in
  tleap -f tleap_script.in
# all 20 rst7 files will be genereated with a constant prmtop file.
}


tleap_solvate_prod () {
  #tleap_start
  ######################## access the file with the variables whcih will come for later analysis
  #echo ${var_selected}
  #echo ${var_list}
  #echo ENDENDENDENDEND
  #for 5 items in the list
  j=-1
  for i in {0..4}
  do
    j=$((1+${j}))
    echo ${j}
    var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
    var_selected=${var_selected//$'\n'/}
    var_selected=${arr0[${j}]}
    #| awk -F"s" '{print $0}'
    echo ${var_selected}
    #p=$(pwd)
    #cd MDprep
    #echo "ambpdb -p ${cwd}/anneal.prmtop -c ${cwd}/${var_selected}_anneal_1000K_flip.ncrst > ${var_selected}_anneal_1000K_flip.pdb"
    #ambpdb -p anneal.prmtop -c ${var_selected}_anneal_1000K_flip.ncrst > ${var_selected}_anneal_1000K_flip.pdb
    #mv ${var_selected}_anneal_1000K_flip.pdb ${p}
    #cd ${p}
    ambpdb -p ${cwd}/anneal.prmtop -c ${cwd}/${var_selected}_anneal_1000K_flip.ncrst > ${var_selected}_anneal_1000K_flip.pdb
    ##ambpdb -p ${cwd}/anneal.prmtop -c ${cwd}/${var_selected}_anneal_1000K_flip.ncrst > ${var_selected}_anneal_1000K_flip.pdb
    ##  fi
    echo ${var_selected} = loadpdb ${var_selected}_anneal_1000K_flip.pdb >> tleap_script.in
    echo addions ${var_selected} Na+ 0 >> tleap_script.in
    echo check ${var_selected} >> tleap_script.in
    echo solvateoct ${var_selected} TIP3PBOX 12.0 >> tleap_script.in
    echo check ${var_selected} >> tleap_script.in
    echo saveamberparm ${var_selected} ${var_selected}_anneal_solv.prmtop ${var_selected}_anneal_solv_flip.rst7 >> tleap_script.in
    ## fi
  done
  echo quit >> tleap_script.in
  tleap -f tleap_script.in

}


tleap_fin_str () {
  #tleap_start
  ######################## access the file with the variables whcih will come for later analysis
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
  echo "IY tleap_fin_str ${FILE}" 
  file2=${FILE}c1_ion_solv.rst7
  #if [ ! -f "${file2}" ]; then
  #  if [ -f "${FILE}c1.pdb " ]; then
        #${FILE}c${zx}.pdb
        echo ${FILE}c1 = loadpdb ${FILE}c1.pdb >> tleap_script.in
        echo addions ${FILE}c1 Na+ 0 >> tleap_script.in
        echo check ${FILE}c1 >> tleap_script.in
        echo solvateoct ${FILE}c1 TIP3PBOX 12.0 >> tleap_script.in
        echo check ${FILE}c1 >> tleap_script.in
        echo saveamberparm ${FILE}c1 ${FILE}c1_ion_solv.prmtop ${FILE}c1_ion_solv.rst7 >> tleap_script.in
        
        echo ${FILE}c2 = loadpdb ${FILE}c2.pdb >> tleap_script.in
        echo addions ${FILE}c2 Na+ 0 >> tleap_script.in
        echo check ${FILE}c2 >> tleap_script.in
        echo solvateoct ${FILE}c2 TIP3PBOX 12.0 >> tleap_script.in
        echo check ${FILE}c2 >> tleap_script.in
        echo saveamberparm ${FILE}c2 ${FILE}c2_ion_solv.prmtop ${FILE}c2_ion_solv.rst7 >> tleap_script.in

  #  fi
  #fi
  done
  echo quit >> tleap_script.in
  tleap -f tleap_script.in

}










