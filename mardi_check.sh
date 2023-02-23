#!/bin/bash

#Declare variable names
NamePA="${PA}"
NamePA=iPr
NameDNA=GTAC
# NameV="${version}"
# NameV=v1

WFPATH=$(pwd)  
runN="0"
scr="${WFPATH}/scripts_in/"
inp="${WFPATH}/inp/${NameDNA}_${NamePA}_inp/"
NamePA_PA="${NamePA}_PA"

var_path="${scr}Mardigras_programs/"
cd $var_path #change var_path to mardigras_programs_path
files=$(ls)
cd $WFPATH
################### options ###############################
# CHIMERA distance Visualisaiton
# Recycling or single run
# Single run
# Analysis (Final Structure, 3DNA, PA dihedrals - Violin Plots)
# Distance Check (R2 RMSD)
################### ####### ###############################


###########################################################
#Check for input DNA_iPr file: 
#PA.frcmod PA.lib DNA_PA_starting.pdb DNA_PA_corma.pdb
#Mardi: 
#.PARM filter.list pseudo.list .INT1
#add else false stop scripts not a directory please prepare files
if [ -d "$inp" ]; then
    echo "$inp is a directory."
    else
    echo "$inp must be a directory."
    exit
fi
###########################################################



###########################################################
#Print into a log file
#Check if variables are coorectly insurted and substituted inref all commands.txt
if test -f "${WFPATH}/NMR_MD_IY.log"; then
    echo "${WFPATH}/NMR_MD_IY.log exists."
    else
    echo "Log file\n" > ${WFPATH}/NMR_MD_IY.log
    echo "${WFPATH}/NMR_MD_IY.log created"
fi

echo -e "$(date)\n" >>${WFPATH}/NMR_MD_IY.log # of course format date to your needs 
echo "Check PA ${PA} is ${NamePA}" >>${WFPATH}/NMR_MD_IY.log
echo "Check dsDNA ${dsDNA} is ${NameDNA}">>${WFPATH}/NMR_MD_IY.log
echo "Check Name_PA iPr_PA to ${NamePA_PA}" >>${WFPATH}/NMR_MD_IY.log
echo "Check NameDNA_NamePA GTAC_iPr to ${NameDNA}_${NamePA}" >>${WFPATH}/NMR_MD_IY.log
echo "Check WFPATH = ${WFPATH}">>${WFPATH}/NMR_MD_IY.log
echo "Check runN = ${runN}" >>${WFPATH}/NMR_MD_IY.log
echo "Check scr = ${scr}" >>${WFPATH}/NMR_MD_IY.log
echo "Check inp = ${inp}" >>${WFPATH}/NMR_MD_IY.log
echo "Check var_path = ${var_path}" >>${WFPATH}/NMR_MD_IY.log
echo "Check files = ${files}" >>${WFPATH}/NMR_MD_IY.log
###########################################################

################### CHECK FOR AMBER #######################

if command -v pmemd.cuda;
then echo "pmemd.cuda exists. Running GPU accelerated AMBER CODE";
echo "pmemd.cuda exists. Running GPU accelerated AMBER CODE" >>${WFPATH}/NMR_MD_IY.log;
AmberRun=pmemd.cuda

else if command -v sander; then echo "sander exists. Running CPU AMBER CODE";
echo "sander exists. Running CPU AMBER CODE">>${WFPATH}/NMR_MD_IY.log;
AmberRun=sander

else echo "Please, install Amber or load module Amber/Intel-21.0";
echo "Please, install Amber or load module Amber/Intel-21.0";>>${WFPATH}/NMR_MD_IY.log;
exit;
fi
fi

#Request the following input files INT1. pseudo.inp, filter.list, start.pdb corma.pdb, wc.txt (optional), PA.lib PA.frcmod 
# if free dna skkip pa.lib and pa.frcmod





#Export every variable so it can be used in following scripts
export NameDNA NamePA NamePA_PA runN WFPATH scr inp AmberRun var_path files

#Check if functions (contained in library_NMR_WF_functions.sh) use the correcct variables, print (cat scripts)

source Library_tleap.sh
source Library_cpptraj.sh
source Library_MD.sh
source Library_T17.sh
source Library_toggle_scripts.sh

################## Building work directories ################## 
worktree    #request_input non
            #required variables WFPATH DNA PA and runN
            #make dir (DP/RunN/MDPrep;Mardi)          
            #return DP               

# update single functions with run) to run$(runN_current) 
#in all cases will be defaul 0 but in recycling then we can make use of the functions


mardigras_calculations
# Can i visualise the restraints from the rand file
# can i compare rand distances to other runs
# confsampling
# annealing
# cd "${WFPATH}/${DP}/Run_0/MDprep"
# cwd=$(pwd)
# select_5
# production

# singlerun
# recycling
# analysis