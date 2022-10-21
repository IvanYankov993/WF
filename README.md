# Welcome to the NMR-Mardi-MD WF (Demo)

The workflow couples the proces of calculating distance restraints from experimental 2D NOESY using the MARDIGRAS ensenble of binaries
with the AMBER restrained molecular dynamics simulation. 

Features include:
  O Batch calculation mode for n number NMR experiments (mixing times 100-400ms, inl other)
  O Reporting 3DNA parameters using cpptraj, PA dihedral angles (requres nomenclature)
  O Option for refining the starting model user specified number of cycles (default 3)
  O Function for selecting the 5 starting conformers with lowest restraint energy penalties 
  O Function for assigned NMR distance restrain visualisation in ChimeraX (under development)
  O Accelerated MARDIGRAS calculations by using GNU parallel (requires seperate installation)

How to use:
1) To run the Demo tutorial make sure your system meets the requirements (below)
2) Download the tutorial 
      Folders: inp, scripts_in
      Scripts: Library_* and demo_NMR_MD_IY.sh
3) make sure scripts (*.sh) and in scripts_in have excutablepermision chmod u+x
4) ./demo_NMR_MD_IY.sh

The executable will create a directory called GTAC_iPr containing all runs Mardi and MD calculations
and a log file with intermediate outputs.

Requirements: 
Linux Ubuntu 20.04 
expect (maybe)
Amber18 (pmemd.cuda) + licence
GPU cuda drivers 
GNU Parallel



PhD_tests

	• Title
	• Description
	• Features
	• How to use
	• Technologies
	• Collaborators
License!
