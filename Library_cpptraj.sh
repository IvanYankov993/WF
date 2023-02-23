#!/bin/bash
#libraryuntction.sh will collect all the funcitons I might need.

######################################################################### #
#              ########  #####  #####  ######  ####      #    #######   # #
#            ##          #    # #    #   #     #   #    # #      #      # # 
#           ##           #####  #####    #     ####    #####     #      # #
#            ##          #      #        #     #  #   #     # #  #      # #
#              ########  #      #        #     #   # #       #  #       # #
######################################################################### #

clust20 () {
    wk_dir=$(pwd) #change to pwd
    #FILE=summary.dat
    #if [ ! -f "$FILE" ]; then
        sed -i '1d' ${scr}cpptraj_clustering.in
        sed -i '1d' ${scr}cpptraj_clustering.in
        x=`echo "trajin "${wk_dir}/${DP}_solv_md2.nc""; cat ${scr}cpptraj_clustering.in`
        echo "$x" > ${scr}cpptraj_clustering.in
        x=`echo "parm "${wk_dir}/${DP}_solv.prmtop""; cat ${scr}cpptraj_clustering.in`
        echo "$x" > ${scr}cpptraj_clustering.in
        cpptraj ${scr}cpptraj_clustering.in
    #fi

    #19 should be n and n should be defined in the clustering procedure above ,potentially include an extra line for the clustering
    j=1
    for i in {0..19}
    do
    FILE=s.c${i}.pdb
    if [ -f "$FILE" ]; then
        j=$((1+${i}))
        mv s.c${i}.pdb s${j}.pdb
    fi
    done
}


fin_str () {
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
        echo "IY CHECK ${FILE}"
        #cpptraj strip WAT NA and cluster into 10
        sed -i '1d' ${scr}cpptraj.in
        sed -i '1d' ${scr}cpptraj.in
        sed -i '1d' ${scr}cpptraj.in
        sed -i '1d' ${scr}cpptraj.in
        #we just need the path to the final trajectory file .nc
        # Check if the water and salts are striped from the trajectroy and seee what does cpptraj do with prmtop parameters
        # require 4 \\\\ to generate one \
        x=`echo "cluster ${FILE}_c  \\\\"; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in
        x=`echo "strip :Na+,WAT"; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in

        x=`echo "trajin "${run_cwd}/${FILE}_prod_1ns_flip.mdcrd""; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in
        x=`echo "parm "${run_cwd}/${FILE}_anneal_solv.prmtop""; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in
        cpptraj ${scr}cpptraj.in
        
        zx=0
        for z in {0..9}
        do
        FILEzx=avg.c${z}.pdb
        if [ -f "$FILEzx" ]; then
            zx=$((1+${z}))
            mv avg.c${z}.pdb ${FILE}avgc${zx}.pdb
            #work with representative structures as the average gives close contact errors
            mv rep.c${z}.pdb ${FILE}c${zx}.pdb
        fi
        done
    done


    ############################################################
    #parm ${FILE}_anneal_solv.prmtop
    #trajin ${FILE}_prod_1ns_flip.mdcrd
    #strip :Na+,WAT
    #cluster ${FILE}_c \
    # kmeans clusters 10 randompoint maxit 500 \
    #   rms :1-25 \
    #   sieve 10 random \
    # out cnumvtime.dat \
    #  summary summary.dat \
    #  info info.dat \
    #  cpopvtime cpopvtime.agr normframe \
    #  repout rep repfmt pdb \
    #  singlerepout singlerep.nc singlerepfmt netcdf \
    #  avgout avg avgfmt pdb
    # run
    ############################################################

    
    # bring the for loop for renaming
    z=1
    #Renaming procedure
    for i in {0..9}
    do
    FILE2=${FILE}_c${i}.pdb
    if [ -f "$FILE2" ]; then
        z=$((1+${i}))
        mv ${FILE2}.pdb ${FILE}c${j}.pdb
    fi
    done
}

fin_str_unrest () {
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
        echo "IY CHECK ${FILE}"
        #cpptraj strip WAT NA and cluster into 10
        sed -i '1d' ${scr}cpptraj.in
        sed -i '1d' ${scr}cpptraj.in
        sed -i '1d' ${scr}cpptraj.in
        sed -i '1d' ${scr}cpptraj.in
        #we just need the path to the final trajectory file .nc
        # Check if the water and salts are striped from the trajectroy and seee what does cpptraj do with prmtop parameters
        # require 4 \\\\ to generate one \
        x=`echo "cluster ${FILE}_c  \\\\"; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in
        x=`echo "strip :Na+,WAT"; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in

        x=`echo "trajin "${run_cwd}/${FILE}_prod_1ns_flip_unrest.mdcrd""; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in
        x=`echo "parm "${run_cwd}/${FILE}_anneal_solv.prmtop""; cat ${scr}cpptraj.in`
        echo "$x" > ${scr}cpptraj.in
        cpptraj ${scr}cpptraj.in
        
        zx=0
        for z in {0..9}
        do
        FILEzx=avg.c${z}.pdb
        if [ -f "$FILEzx" ]; then
            zx=$((1+${z}))
            mv avg.c${z}.pdb ${FILE}avgc${zx}.pdb
            #work with representative structures as the average gives close contact errors
            mv rep.c${z}.pdb ${FILE}c${zx}.pdb
        fi
        done
    done


    ############################################################
    #parm ${FILE}_anneal_solv.prmtop
    #trajin ${FILE}_prod_1ns_flip.mdcrd
    #strip :Na+,WAT
    #cluster ${FILE}_c \
    # kmeans clusters 10 randompoint maxit 500 \
    #   rms :1-25 \
    #   sieve 10 random \
    # out cnumvtime.dat \
    #  summary summary.dat \
    #  info info.dat \
    #  cpopvtime cpopvtime.agr normframe \
    #  repout rep repfmt pdb \
    #  singlerepout singlerep.nc singlerepfmt netcdf \
    #  avgout avg avgfmt pdb
    # run
    ############################################################

    
    # bring the for loop for renaming
    z=1
    #Renaming procedure
    for i in {0..9}
    do
    FILE2=${FILE}_c${i}.pdb
    if [ -f "$FILE2" ]; then
        z=$((1+${i}))
        mv ${FILE2}.pdb ${FILE}c${j}.pdb
    fi
    done
}


clust20_loop () {
    wk_dir=$(pwd) #change to pwd
    #FILE=summary.dat
    #if [ ! -f "$FILE" ]; then
        sed -i '1d' ${scr}cpptraj_clustering.in
        sed -i '1d' ${scr}cpptraj_clustering.in
        x=`echo "trajin "${wk_dir}/${DP}_solv_md2.nc""; cat ${scr}cpptraj_clustering.in`
        echo "$x" > ${scr}cpptraj_clustering.in
        x=`echo "parm "${wk_dir}/${FILE}c1_ion_solv.prmtop""; cat ${scr}cpptraj_clustering.in`
        echo "$x" > ${scr}cpptraj_clustering.in
        cpptraj ${scr}cpptraj_clustering.in
    #fi

    #19 should be n and n should be defined in the clustering procedure above ,potentially include an extra line for the clustering
    j=1
    for i in {0..19}
    do
    FILE=s.c${i}.pdb
    if [ -f "$FILE" ]; then
        j=$((1+${i}))
        mv s.c${i}.pdb s${j}.pdb
    fi
    done
}

# consider doing T_1 - (PA_DNACOMPLEXFOLDER)structure, topology, rst, mol2, forcmod, 
#tleap solvation protolcand others cpptraj clustering
#cpptraj protocols - clustering anlysis
#MD simulaiton protocls .in files





# 3DNA () {
#       j=-1
#         for i in {0..4}
#         do
#         j=$((1+${j}))
#         echo ${j}
#         var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
#         var_selected=${var_selected//$'\n'/}
#         FILE=${var_selected}
#         FILE=${arr0[${j}]}
#         echo ${scr}${var_selected}
#         echo "IY CHECK ${FILE}"
#         #cpptraj strip WAT NA, give traj in and topology
#         sed -i '1d' ${scr}3DNA.in
#         sed -i '1d' ${scr}3DNA.in
#         sed -i '1d' ${scr}3DNA.in
    
#         x=`echo "strip :Na+,WAT"; cat ${scr}3DNA.in`
#         echo "$x" > ${scr}3DNA.in

#         x=`echo "trajin "${run_cwd}/${FILE}_prod_1ns_flip.mdcrd""; cat ${scr}3DNA.in`
#         echo "$x" > ${scr}3DNA.in
#         x=`echo "parm "${run_cwd}/${FILE}_anneal_solv.prmtop""; cat ${scr}3DNA.in`
#         echo "$x" > ${scr}3DNA.in
#         mkdir ${FILE}
#         cd ${FILE}
#         cpptraj ${scr}3DNA.in
#         cd ..//
        
#     done


#     ############################################################
#     # parm GTAC_iPr_vac.prmtop
#     # trajin s3_uMD_centre_noWAT_605ns_1005.nc
#     #
#     # nastruct, distances, dihedrals, 
#     # run
#     ############################################################

# }
3DNA () {
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
        echo "IY CHECK ${FILE}"
        #cpptraj strip WAT NA, give traj in and topology
        sed -i '1d' ${scr}3DNA.in
        sed -i '1d' ${scr}3DNA.in
        sed -i '1d' ${scr}3DNA.in
    
        x=`echo "strip :Na+,WAT"; cat ${scr}3DNA.in`
        echo "$x" > ${scr}3DNA.in

        x=`echo "trajin "${run_cwd}/${FILE}_prod_1ns_flip.mdcrd""; cat ${scr}3DNA.in`
        echo "$x" > ${scr}3DNA.in
        x=`echo "parm "${run_cwd}/${FILE}_anneal_solv.prmtop""; cat ${scr}3DNA.in`
        echo "$x" > ${scr}3DNA.in
        mkdir ${FILE}
        cd ${FILE}
        cpptraj ${scr}3DNA.in
        cd ..//
        
    done


    ############################################################
    # parm GTAC_iPr_vac.prmtop
    # trajin s3_uMD_centre_noWAT_605ns_1005.nc
    #
    # nastruct, distances, dihedrals, 
    # run
    ############################################################

}


3DNA_unrest () {
    #   j=-1
    #     for i in {0..4}
    #     do
    #     j=$((1+${j}))
    #     echo ${j}
    #     var_selected=$(echo "${arr0[${j}]}" | awk -F"_" '{print $1}')
    #     var_selected=${var_selected//$'\n'/}
    #     FILE=${var_selected}
    #     FILE=${arr0[${j}]}
    #     echo ${scr}${var_selected}
    #     echo "IY CHECK ${FILE}"
    #     #cpptraj strip WAT NA, give traj in and topology
    #     sed -i '1d' ${scr}3DNA.in
    #     sed -i '1d' ${scr}3DNA.in
    #     sed -i '1d' ${scr}3DNA.in
    
    #     x=`echo "strip :Na+,WAT"; cat ${scr}3DNA.in`
    #     echo "$x" > ${scr}3DNA.in

    #     x=`echo "trajin "${run_cwd}/${FILE}_prod_1ns_flip_unrest.mdcrd""; cat ${scr}3DNA.in`
    #     echo "$x" > ${scr}3DNA.in
    #     x=`echo "parm "${run_cwd}/${FILE}_anneal_solv.prmtop""; cat ${scr}3DNA.in`
    #     echo "$x" > ${scr}3DNA.in
    #     mkdir ${FILE}
    #     cd ${FILE}
    #     cpptraj ${scr}3DNA.in
    #     cd ..//
        
    # done
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
        echo "IY CHECK ${FILE}"
        #cpptraj strip WAT NA, give traj in and topology
        sed -i '1d' ${scr}3DNA.in
        sed -i '1d' ${scr}3DNA.in
        sed -i '1d' ${scr}3DNA.in
    
        x=`echo "strip :Na+,WAT"; cat ${scr}3DNA.in`
        echo "$x" > ${scr}3DNA.in

        x=`echo "trajin "${run_cwd}/${FILE}_prod_1ns_flip_unrest.mdcrd""; cat ${scr}3DNA.in`
        echo "$x" > ${scr}3DNA.in
        x=`echo "parm "${run_cwd}/${FILE}_anneal_solv.prmtop""; cat ${scr}3DNA.in`
        echo "$x" > ${scr}3DNA.in
        mkdir ${FILE}
        cd ${FILE}
        cpptraj ${scr}3DNA.in
        cd ..//
        
    done

    ############################################################
    # parm GTAC_iPr_vac.prmtop
    # trajin s3_uMD_centre_noWAT_605ns_1005.nc
    #
    # nastruct, distances, dihedrals, 
    # run
    ############################################################

}