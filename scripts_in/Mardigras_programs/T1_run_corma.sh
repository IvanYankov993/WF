#!/bin/bash

#use an external loop to feed in C and ns files.
read -p 'Whats the name of the Complex, without .pdb? (e.g. DNA_PA_other) ' C
read -p 'How many correlation times in ns? (e.g. 1-8) lower bracket ' ns
read -p 'How many correlation times in ns? (e.g. 1-8) upper bracket' nsh
#this will be script for all variables

Complex="${C}"
ns_lower_bracket=ns
ns_count="${nsh}"

for ((i=$ns_lower_bracket; i<=$ns_count; i++)); do
	./S1_iso_corma_expect.sh ${C} ${i}
#S1_iso_ will be form of templates if we use mod loc ani a new template must be called. 
#because they have different number of questions.
done

export Complex ns_lower_bracket ns_count C ns

./T2_run_mardigras.sh
./T3_run_rand_restr.sh
./S4_run_m2ahomo.sh ${C}

#this file will have to copy and delete the corma-mardi-mardigras-rand-restr-m2ahomo scripts to the destination file where we are operating usuallly T3 in NMR-WF for each specific user and complex.
#probably remove them at the end
#also prior to executing script we need to copy all the input files which include (pseudo.inp, starting pdb file and any updated pdb from the MD simulation if starting template has an impact, the NMR list files + mardi sccript to generate Int1 or just the INT.1, finally the intrearesidue restraint ype which must be filtered in the last step)

#summary; 3 
#initial nmr.list file or int.1 
# pseudo.inp
#filter.lis

#nb still need a finciton to update the maximum intensity for mardigras in the parm file. a new variable (kinda have a code from the highest energy). 
