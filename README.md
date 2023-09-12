# EnKF Observation Aware RTPS within GSI

This repository contains modifications to the EnKF code in order to enable
observation-aware RTPS inflation for radar reflectivity DA. This allows for 
spurious hydrometeor locations, as defined by an observation mask file 
(fv3sar_tile1_mask), to be inflated according to a 2nd reduced alpha value. 
This reduced value should help reduce spurious hydrometeors from being reintroduced 
in the analyzed ensemble members by the RTPS inflation.

In order to use, please see the descriptions contained in file README_OARTPS. 
Note the GSI can be compiled as usual according to INSTALL.md 

To clone, issue the following github commands

git clone https://github.com/NicholasGasperoni/GSI.git
git submodule update --init --recursive

Points of contact:
Nicholas Gasperoni (ngaspero@ou.edu)
Yongming Wang (yongming.wang@ou.edu)
Xuguang Wang (xuguang.wang@ou.edu)



