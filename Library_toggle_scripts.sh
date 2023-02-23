#!/bin/bash
#library_toggle_scripts.sh will collect:

####################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
#############################single run and analysis##############################

confsampling () {
	################## Confromation sampling ################## 

	cd "${WFPATH}/${DP}/Run_0/MDprep"
	tleap_start #requires variables inp NamePA_PA; 
		    #sets parameters (first 5 lines in each leap script.

	tleap_conf  #requires variables inp and DP;
		    #produces prmtop rst7 in vaccum, neutralised, solvated.

	min12md12   #requires variables scr and DP 
		    #runs pmemd.cuda for an unrestrained simulaiton (sampling)

	####see if we want to add all trajectories + add analysis of MD1
	####introduce .out analysis to see if its stable,save the graphs. grace command directly to png. + one morecoomand one to extract file and the seocnd to visualise

	clust20     #requires variables scr DP and correct directory 
		    #kmeasn clustering 20 representative pdb, name formating 
		    #s1-20.pdb

}

annealing () {

################## restrained Annealing + Select 5 ##################

	cd "${WFPATH}/${DP}/Run_0/MDprep"
	cwd=$(pwd)
	cp "${c1wd}/${DP}_corma.rest" $cwd
    
	tleap_start
	tleap_anneal_rst7   # requires s1-20 from clust20
		            # anneal.prmtop s1-20.rst7
	annealMDrest

	select_5            # requires to be in MDprep
		            # requires annealiMDrest .out files
		            # generates arr0[0-4], cruicial for run_5ns and for loop
	cd ..//


}

production () {
	cd "${WFPATH}/${DP}/Run_0/MDprep"
	cwd=$(pwd)
	echo $cwd
	select_5

	cd "${WFPATH}/${DP}/Run_0"
	cwd2=$(pwd)
	cp "${cwd}/${DP}_corma.rest" $cwd2
################## production run of selected 5 sN.pdb ##################
	tleap_start
	tleap_solvate_prod  # requires arr0[0-4] cwd
		            # produces arr0[0-4].prmtop rst7 
	run_5ns_prod        # requires arr0[0-4] scr
	run_5ns_unrest_prod        # requires arr0[0-4] scr
	run_cwd=$(pwd)

}

##################################################################################
##################################################################################
##################################################################################
##################################################################################
#############################single run and analysis##############################


singlerun () {
	
    ################## Mardi restraints generation ################## 
	# mardigras_calculations

    ################## Confromation sampling ################## 
	cd "${WFPATH}/${DP}/Run_0/MDprep"
	tleap_start #requires variables inp NamePA_PA; 
		    #sets parameters (first 5 lines in each leap script.

	tleap_conf  #requires variables inp and DP;
		    #produces prmtop rst7 in vaccum, neutralised, solvated.

	min12md12   #requires variables scr and DP 
		    #runs pmemd.cuda for an unrestrained simulaiton (sampling)

	####see if we want to add all trajectories + add analysis of MD1
	####introduce .out analysis to see if its stable,save the graphs. grace command directly to png. + one morecoomand one to extract file and the seocnd to visualise

	clust20     #requires variables scr DP and correct directory 
		    #kmeasn clustering 20 representative pdb, name formating 
		    #s1-20.pdb

    ################## restrained Annealing + Select 5 ##################

	cd "${WFPATH}/${DP}/Run_0/MDprep"
	cwd=$(pwd)
	cp "${c1wd}/${DP}_corma.rest" $cwd
    
	tleap_start
	tleap_anneal_rst7   # requires s1-20 from clust20
		            # anneal.prmtop s1-20.rst7
	annealMDrest

	select_5            # requires to be in MDprep
		            # requires annealiMDrest .out files
		            # generates arr0[0-4], cruicial for run_5ns and for loop
	cd ..//

	################## production run of selected 5 sN.pdb ##################
	tleap_start
	tleap_solvate_prod  # requires arr0[0-4] cwd
		            # produces arr0[0-4].prmtop rst7 
	run_5ns_prod        # requires arr0[0-4] scr
	run_5ns_unrest_prod        # requires arr0[0-4] scr
	run_cwd=$(pwd)

	################## Analysis 3DNA, PA dihedrals, H-bonds, Representative cluster ##################

	#Representative cluster / Final Structure
	# Unrestrainted representative structure
	fin_str_unrest         # requires arr0[0-4] scr  
		            # produces 2 rep.c -> c
		            #NB! Revie script syntax error

	tleap_start         
	tleap_fin_str       # requires arr0[0-4] scr
		            # produces pmrtop rst7 files

	md_fin_str_unrest          # requires arr0[0-4] scr
		            # produces minimised final.pdb final_corma.pdb  
	
	
	# Restrained representative structuree
	fin_str         # requires arr0[0-4] scr  
		            # produces 2 rep.c -> c
		            #NB! Revie script syntax error

	tleap_start         
	tleap_fin_str       # requires arr0[0-4] scr
		            # produces pmrtop rst7 files

	md_fin_str          # requires arr0[0-4] scr
		            # produces minimised final.pdb final_corma.pdb  
	cp_cwd=$(pwd)


	##### move to Run 2 (final pdb, prmtop, ncrst) 
	##### strip from Wat and Na+ (pdb)
	##### Run Mardi Calculaitons (pdb)§ 
	##### Run min12md12 (prmto, ncrst)
	##### clust_20
	##### anneal_rest
	##### select_5
	##### prod run
	##### fin_str tleap start tleapt_fin_str md_fin_str (repeat move to run 3)
	echo "IY CHECK: ${arr0[0]}"
}
##################################################################################
##################################################################################
##################################################################################
##################################################################################
################## Recycling of MARDI-AMBER refinement ##################
	recycling () {
	#conditional sentence: check if files in run_0 exists.

	# Requires final_corma.pdb cp_cwd arr0[0-4] runN
	# Requires arr0[0-4]c1_min4.ncrst arr0[0-4]c1_ion_solv.prmtop"
	for i in $(seq 1 ${runN}) #${runN})
	do

	    ################### Check files exists report to LOG ####################
	    # condition is has a single run beenr un if not run it or Y or N let user decide
	    # Save function in a seperate library. 
	    # add log step of condition found, if file doesnt exists exit job with reason why.
	    echo "Currently Run number ${i} is running! -comment by IY" >${WFPATH}/NMR_MD_IY.log
	    echo "Currently Run number ${i} is running! -comment by IY" 
	    ip=$((${i}-1))
	    echo ${ip} >${WFPATH}/NMR_MD_IY.log
	    echo ${ip} 
	    cd "${WFPATH}/${DP}/Run_${ip}/MDprep"
	    cwd=$(pwd)
	    select_5            # requires to be in MDprep
		                # requires annealiMDrest .out files
		                # generates arr0[0-4], cruicial for run_5ns and for loop
	    ################### prepare to move files  ####################
	    cd ..//
	    cp_cwd=$(pwd)
	    j=1
	    echo ${j}
	    var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
	    var_selected=${var_selected//$'\n'/}
	    FILE=${var_selected}
	    FILE=${arr0[${j}]}
	    #add waiting until parallel is done to do production runs
	    echo "${FILE}c1_min4.ncrst"
	    echo "${FILE}c1_ion_solv.prmtop"
	    cd "${WFPATH}/${DP}/Run_${i}/MDprep"
	    cp "${cp_cwd}/${FILE}c1_min4.ncrst" "${WFPATH}/${DP}/Run_${i}/MDprep"
	    cp "${cp_cwd}/${FILE}c1_final_corma.pdb" "${WFPATH}/${DP}/Run_${i}/Mardi"
	    cp "${cp_cwd}/${FILE}c1_ion_solv.prmtop" "${WFPATH}/${DP}/Run_${i}/MDprep"
	    
	    ################### Mardi file renaming and run.sh ####################
	    cd "${WFPATH}/${DP}/Run_${i}/Mardi"
	    c1wd=$(pwd)
	    #we do not have to copy corma.pdb from inp
	    cp "${FILE}c1_final_corma.pdb" "${FILE}c1_final_corma_back_up.pdb"
	    mv "${FILE}c1_final_corma.pdb" "${DP}_corma.pdb"
	    cp ${inp}*.INT.1 $c1wd
	    cp "${inp}pseudo.inp" $c1wd
	    cp "${inp}filter.list" $c1wd 
	    cp "${scr}run.sh" $c1wd
	    ./run.sh
	    cp "${inp}wc.txt" ${c1wd}
	    cat wc.txt >> "${DP}_corma.rest"
	    c1wd=$(pwd)

	    ################### rMD run + clustering ####################
	    cd "${WFPATH}/${DP}/Run_${i}/MDprep"
	    cwd=$(pwd)
	    cp "${c1wd}/${DP}_corma.rest" ${cwd}

	    ###########################check point exit#################################################
	    ########## unsure of the commands below ###########
	    # not needed tleap_start #requires inp variable avail; Makes the first 5 lines for each t leap file
	    # not needed tleap_conf_loop #requires access to DP and inp
	    min12md12_loop # see if we want to add all trajectories + add analysis of MD1
	    ####introduce .out analysis to see if its stable,save the graphs. grace command directly to png. + one morecoomand one to extract file and the seocnd to visualise
	    clust20_loop #equivalent to T4 generate 20 clusters
	    echo "Loop is working"
	    tleap_start
	    tleap_anneal_rst7
	    annealMDrest
	    #unset arr0
	    #arr0=("${arr0[@]}")
	    ############################################################
	    select_5 #exports var list arr0[0-4]
	    
	    echo "CHEK THIS ${arr0[@]}"
	    echo end
	    cd ..//


	    tleap_start
	    tleap_solvate_prod
	    ####### run using parallel the produciton run + analysis
	    run_5ns_prod
	    run_cwd=$(pwd)
	    ###### add analysis using 3DNA, dihedrals, h bonds, more mds + final structure generations

	    fin_str
	    tleap_start
	    tleap_fin_str
	    md_fin_str #gets sN(5)c1c2.pdb (solvate and neutralised)
	    cp_cwd=$(pwd)
	done
}


analysis () {
	#conditional sentence: check if files in run_0 exists.

	# Requires final_corma.pdb cp_cwd arr0[0-4] runN
	# Requires arr0[0-4]c1_min4.ncrst arr0[0-4]c1_ion_solv.prmtop"
	for i in $(seq 1 ${runN}) #${runN})
	do

	    ################### Check files exists report to LOG ####################
	    echo "Currently Run number ${i} is running! -comment by IY" >>${WFPATH}/NMR_MD_IY.log
	    echo "Currently Run number ${i} is running! -comment by IY" 
	    ip=$((${i}-1))
	    echo ${ip} >>${WFPATH}/NMR_MD_IY.log
	    echo ${ip} 
	    cd "${WFPATH}/${DP}/Run_${ip}/MDprep"
	    cwd=$(pwd)
	    select_5        # requires to be in MDprep
		                # requires annealiMDrest .out files
		                # generates arr0[0-4], cruicial for run_5ns and for loop
	    ################### prepare to move files  ####################
	    cd ..//

		################ check cp and run cwd variables
	    cp_cwd=$(pwd)
		run_cwd=$(pwd)
		3DNA
       
	done
}

run0_analysis () {

	cd "${WFPATH}/${DP}/Run_0/MDprep"
	cwd=$(pwd)
	echo $cwd
	select_5
	cd ..//
	run_cwd=$(pwd)

	fin_str_unrest         # requires arr0[0-4] scr  
					# produces 2 rep.c -> c
					#NB! Revie script syntax error

	tleap_start         
	tleap_fin_str       # requires arr0[0-4] scr
					# produces pmrtop rst7 files

	md_fin_str_unrest
	cp_cwd=$(pwd)

	3DNA_unrest
	mkdir fin_s_unrest
	mv s*c*.* fin_s_unrest 
	mv cnumvtime.dat cpopvtime.agr info.dat singlerep.nc summary.dat mdinfo fin_s_unrest
	mv ${arr0[0]} fin_analysis_s_unrest
	mv ${arr0[1]} fin_analysis_s_unrest
	mv ${arr0[2]} fin_analysis_s_unrest
	mv ${arr0[3]} fin_analysis_s_unrest
	mv ${arr0[4]} fin_analysis_s_unrest



	# Restrained representative structuree
	fin_str         # requires arr0[0-4] scr  
					# produces 2 rep.c -> c
					#NB! Revie script syntax error

	tleap_start         
	tleap_fin_str       # requires arr0[0-4] scr
					# produces pmrtop rst7 files

	md_fin_str          # requires arr0[0-4] scr
	# 	            # produces minimised final.pdb final_corma.pdb  
	cp_cwd=$(pwd)



	3DNA
	mkdir fin_s_rest
	mv s*c*.* fin_s_rest #s*c*_*
	mv cnumvtime.dat cpopvtime.agr info.dat singlerep.nc summary.dat mdinfo fin_s_rest
	mv ${arr0[0]} fin_analysis_s_rest
	mv ${arr0[1]} fin_analysis_s_rest
	mv ${arr0[2]} fin_analysis_s_rest
	mv ${arr0[3]} fin_analysis_s_rest
	mv ${arr0[4]} fin_analysis_s_rest


}





















fin_str_and_analysis_rest_and_unrest () {
	cd "${WFPATH}/${DP}/Run_${ip}/MDprep"
	cwd=$(pwd)
	# select_5        # requires to be in MDprep
					# requires annealiMDrest .out files
					# generates arr0[0-4], cruicial for run_5ns and for loop
	################### prepare to move files  ####################
	cd ..//
	run_cwd=$(pwd)
	echo run_cwd
	# echo $(ls)
	# Restrained representative structuree
	fin_str         # requires arr0[0-4] scr  
		            # produces 2 rep.c -> c
		            #NB! Revie script syntax error

	tleap_start         
	tleap_fin_str       # requires arr0[0-4] scr
		            # produces pmrtop rst7 files

	md_fin_str          # requires arr0[0-4] scr
	# 	            # produces minimised final.pdb final_corma.pdb  
	cp_cwd=$(pwd)

	#mv all s_directories into restraint_s analysis



	#     select_5 #exports var list arr0[0-4]
	    
	#     echo "CHEK THIS ${arr0[@]}"
	#     echo end
	#     cd ..//


	#     tleap_start
	#     tleap_solvate_prod
	#     ####### run using parallel the produciton run + analysis
	#     run_5ns_prod
	#     run_cwd=$(pwd)
	#     ###### add analysis using 3DNA, dihedrals, h bonds, more mds + final structure generations

	#     fin_str
	#     tleap_start
	#     tleap_fin_str
	#     md_fin_str #gets sN(5)c1c2.pdb (solvate and neutralised)
	#     cp_cwd=$(pwd)



	##### move to Run 2 (final pdb, prmtop, ncrst) 
	##### strip from Wat and Na+ (pdb)
	##### Run Mardi Calculaitons (pdb)§ 
	##### Run min12md12 (prmto, ncrst)
	##### clust_20
	##### anneal_rest
	##### select_5
	##### prod run
	##### fin_str tleap start tleapt_fin_str md_fin_str (repeat move to run 3)
	echo "IY CHECK: ${arr0[0]}"

#conditional sentence: check if files in run_0 exists.

	# Requires final_corma.pdb cp_cwd arr0[0-4] runN
	# Requires arr0[0-4]c1_min4.ncrst arr0[0-4]c1_ion_solv.prmtop"
	for i in $(seq 1 ${runN}) #${runN})
	do

	    ################### Check files exists report to LOG ####################
	    echo "Currently Run number ${i} is running! -comment by IY" >>${WFPATH}/NMR_MD_IY.log
	    echo "Currently Run number ${i} is running! -comment by IY" 
	    ip=$((${i}-1))
	    echo ${ip} >>${WFPATH}/NMR_MD_IY.log
	    echo ${ip} 
	    cd "${WFPATH}/${DP}/Run_${ip}/MDprep"
	    cwd=$(pwd)
	    select_5        # requires to be in MDprep
		                # requires annealiMDrest .out files
		                # generates arr0[0-4], cruicial for run_5ns and for loop
	    ################### prepare to move files  ####################
	    cd ..//

		################ check cp and run cwd variables
	    cp_cwd=$(pwd)
		run_cwd=$(pwd)
		3DNA
	done
	mkdir fin_analysis_s_rest   
	# mv $(ls -d s*) fin_analysis_s_rest
	echo $(ls -d)
	echo ${arr0[0]} ${arr0[1]} ${arr0[2]} ${arr0[3]} ${arr0[4]}
	mv ${arr0[0]} fin_analysis_s_rest
	mv ${arr0[1]} fin_analysis_s_rest
	mv ${arr0[2]} fin_analysis_s_rest
	mv ${arr0[3]} fin_analysis_s_rest
	mv ${arr0[4]} fin_analysis_s_rest 
	fin_str_unrest         # requires arr0[0-4] scr  
		            # produces 2 rep.c -> c
		            #NB! Revie script syntax error

	tleap_start         
	tleap_fin_str       # requires arr0[0-4] scr
		            # produces pmrtop rst7 files

	md_fin_str_unrest	# requires arr0[0-4] scr
	# 	            # produces minimised final.pdb final_corma.pdb  
	# cp_cwd=$(pwd)
	echo "IY CHECK: ${arr0[0]}"

#conditional sentence: check if files in run_0 exists.

	# Requires final_corma.pdb cp_cwd arr0[0-4] runN
	# Requires arr0[0-4]c1_min4.ncrst arr0[0-4]c1_ion_solv.prmtop"
	for i in $(seq 1 ${runN}) #${runN})
	do

	    ################### Check files exists report to LOG ####################
	    echo "Currently Run number ${i} is running! -comment by IY" >>${WFPATH}/NMR_MD_IY.log
	    echo "Currently Run number ${i} is running! -comment by IY" 
	    ip=$((${i}-1))
	    echo ${ip} >>${WFPATH}/NMR_MD_IY.log
	    echo ${ip} 
	    cd "${WFPATH}/${DP}/Run_${ip}/MDprep"
	    cwd=$(pwd)
	    select_5        # requires to be in MDprep
		                # requires annealiMDrest .out files
		                # generates arr0[0-4], cruicial for run_5ns and for loop
	    ################### prepare to move files  ####################
	    cd ..//

		################ check cp and run cwd variables
	    cp_cwd=$(pwd)
		run_cwd=$(pwd)
		3DNA_unrest
	# mkdir fin_analysis_s_unrest   
	# mv $(ls -d s*) fin_analysis_s_unrest
	done
	echo "IY CHECK: ${arr0[0]}"
}