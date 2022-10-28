#!/bin/bash

#Declare variable names
NamePA="${PA}"
NamePA=iPr
NameDNA="${dsDNA}"
NameDNA=GTAC
WFPATH=$(pwd)  
runN="3"
scr="${WFPATH}/scripts_in/"
inp="${WFPATH}/inp/${NameDNA}_${NamePA}_inp/"
NamePA_PA="${NamePA}_PA"


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

echo -e "$(date)\n" >${WFPATH}/NMR_MD_IY.log # of course format date to your needs 
echo "Check ${PA} is ${NamePA}" >${WFPATH}/NMR_MD_IY.log
echo "Check ${dsDNA} is ${NameDNA}">${WFPATH}/NMR_MD_IY.log
echo "iPr_PA to ${NamePA_PA}" >${WFPATH}/NMR_MD_IY.log
echo "GTAC_iPr to ${NameDNA}_${NamePA}" >${WFPATH}/NMR_MD_IY.log
echo "Check WFPATH = ${WFPATH}" >${WFPATH}/NMR_MD_IY.log
echo "Check runN = ${runN}" >${WFPATH}/NMR_MD_IY.log
echo "Check scr = ${scr}" >${WFPATH}/NMR_MD_IY.log
echo "Check inp = ${inp}" >${WFPATH}/NMR_MD_IY.log
echo "Check {NamePA_PA} = ${NamePA_PA}" >${WFPATH}/NMR_MD_IY.log
###########################################################

################### CHECK FOR AMBER #######################

if command -v pmemd.cuda;
then echo "pmemd.cuda exists. Running GPU accelerated AMBER CODE";
AmberRun=pmemd.cuda

else if command -v sander; then echo "sander exists. Running CPU AMBER CODE"; 
AmberRun=sander

else echo "Please, install Amber or load module Amber/Intel-21.0"; exit;
fi
fi







#Export every variable so it can be used in following scripts
export NameDNA NamePA NamePA_PA runN WFPATH scr inp AmberRun

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

singlerun
recycling
analysis