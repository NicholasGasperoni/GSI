#!/bin/ksh
set -ux

## set up common directories, utilities and environment variables
## for different platforms, and assign user specific parameters.

source  ./vsdbTop_gui.txt

machine=${1:-WCOSS}
machine=$(echo $machine|tr '[a-z]' '[A-Z]')
export rc=0


#==================================
## machine-independent parameters
#==================================
export anl_type=gfs            ;#analysis type: gfs, gdas, ecmwf, manl or canl
                                ##gfs/gdas--own anl of each exps, manl--mean in expnlist; canl--mean of GFS,EC and UK.
export sfcvsdb="YES"           ;#include the group of surface variables       
export gd=G2                   ;#grid resoultion on which vsdb stats are computed, G2->2.5deg, G3->1deg, G4->0.5deg
export doftp="NO"             ;#whether or not to send maps to web server
export scppgb="NO"             ;#copy files between machine? need passwordless ssh
export batch="YES"             ;#run jobs at batch nodes                              
export scorecard="YES"          ;#create scorecard text files and web display plate                          
if [ $machine != IBM -a $machine != WCOSS ]; then 
 export doftp="NO"
fi

#==================================
## user-specific parameters
#==================================
if [ $machine = IBM ]; then
 export vsdbsave=/global/noscrub/$LOGNAME/archive/vsdb_data  ;#place where vsdb database is saved
 export ACCOUNT=GFS-MTN                                ;#ibm computer ACCOUNT task
 export CUE2RUN=1                                      ;#dev or devhigh or 1
 export CUE2FTP=1                                      ;#queue for data transfer
 export GROUP=g01                                      ;#group of account, g01 etc
 if [ $doftp = YES ]; then
  export webhost=${webhost:-emcrzdm.ncep.noaa.gov}     ;#host for web display
  export webhostid=${webhostid:-$LOGNAME}              ;#login id on webhost 
  export ftpdir=${ftpdir:-/home/people/emc/www/htdocs/gmb/$webhostid/vsdb}   ;#where maps are displayed on webhost     
 fi 

#----------------------------
elif [ $machine = WCOSS ]; then
 chost=`echo $(hostname) |cut -c 1-1`
 export vsdbsave=/global/noscrub/$LOGNAME/archive/vsdb_data  ;#place where vsdb database is saved
 export ACCOUNT=GFS-MTN                                ;#ibm computer ACCOUNT task
 export CUE2RUN=dev                                    ;#dev or dev_shared         
 export CUE2FTP=transfer                               ;#queue for data transfer
 export GROUP=g01                                      ;#group of account, g01 etc
 if [ $doftp = YES ]; then
  export webhost=${webhost:-emcrzdm.ncep.noaa.gov}     ;#host for web display
  export webhostid=${webhostid:-$LOGNAME}              ;#login id on webhost 
  export ftpdir=${ftpdir:-/home/people/emc/www/htdocs/gmb/$webhostid/vsdb}   ;#where maps are displayed on webhost    
 fi 

#----------------------------
elif [ $machine = ZEUS ]; then
#dxu  export vsdbsave=/scratch2/portfolios/NCEPDEV/global/noscrub/$LOGNAME/archive/vsdb_data  ;#place where vsdb database is saved
 # export vsdbsave=/scratch2/portfolios/NESDIS/drt/save/Tong.Zhu/gfs_pgb/prt670
 export vsdbsave=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/output/vsdb_data
 export ACCOUNT=h-sandy                                  ;#computer ACCOUNT task
 export CUE2RUN=batch                                  ;#default to batch queue
 export CUE2FTP=batch                                  ;#queue for data transfer
 export GROUP=g01                                      ;#group of account, g01 etc
 export doftp="NO"                                     ;#whether or not to sent maps to ftpdir
 if [ $doftp = YES ]; then
  export webhost=${webhost:-emcrzdm.ncep.noaa.gov}     ;#host for web display
  export webhostid=${webhostid:-$LOGNAME}              ;#login id on webhost 
  export ftpdir=${ftpdir:-/home/people/emc/www/htdocs/gmb/$webhostid/vsdb}   ;#where maps are displayed on webhost            
 fi 

#----------------------------
elif [ $machine = BADGER ]; then
 export vsdbsave=/data/users/dxu/vsdb_workspace/data/output/vsdb_data  ;#place where vsdb database is saved
 export ACCOUNT=glbss                                  ;#computer ACCOUNT task
 export CUE2RUN=batch                                  ;#default to batch queue
 export CUE2FTP=batch                                  ;#queue for data transfer
 export GROUP=g01                                      ;#group of account, g01 etc
 export doftp="NO"                                     ;#whether or not to sent maps to ftpdir
 if [ $doftp = YES ]; then
  export webhost=${webhost:-emcrzdm.ncep.noaa.gov}     ;#host for web display
  export webhostid=${webhostid:-$LOGNAME}              ;#login id on webhost 
  export ftpdir=${ftpdir:-/home/people/emc/www/htdocs/gmb/$webhostid/vsdb}   ;#where maps are displayed on webhost            
 fi 

#----------------------------
elif [ $machine = CARDINAL ]; then
 export VSDBHOME=${ENV_VSDBHOME}
 export WORKSPACE=${ENV_WORKSPACE}

 export vsdbsave=${WORKSPACE}/data/output/vsdb_data
 export ACCOUNT=${ENV_ACCOUNT}
 export CUE2RUN=${ENV_CUE2RUN}
 export CUE2FTP=${ENV_CUE2FTP}
 export GROUP=${ENV_GROUP}
 export doftp=${EVN_DOFTP}
 if [ $doftp = YES ]; then
  export webhost=${webhost:-emcrzdm.ncep.noaa.gov}     ;#host for web display
  export webhostid=${webhostid:-$LOGNAME}              ;#login id on webhost 
  export ftpdir=${ftpdir:-/home/people/emc/www/htdocs/gmb/$webhostid/vsdb}   ;#where maps are displayed on webhost            
 fi 

#----------------------------
elif [ $machine = JET ]; then
 export vsdbsave=/pan2/projects/gnmip/$LOGNAME/noscrub/archive/vsdb_data  ;#place where vsdb database is saved
 export ACCOUNT=gnmip                                  ;#computer ACCOUNT task
 export CUE2RUN=hfip                                   ;#default to batch queue
 export CUE2FTP=hfip                                   ;#queue for data transfer
 export GROUP=gnmip                                    ;#group of account, g01 etc
 export doftp="NO"                                     ;#whether or not to sent maps to ftpdir
 if [ $doftp = YES ]; then
  export webhost=${webhost:-emcrzdm.ncep.noaa.gov}     ;#host for web display
  export webhostid=${webhostid:-$LOGNAME}              ;#login id on webhost 
  export ftpdir=${ftpdir:-/home/people/emc/www/htdocs/gmb/$webhostid/vsdb}   ;#where maps are displayed on webhost            
 fi 

#----------------------------
else
 echo "machine $machine is not supportted by NCEP/ECM"
 echo "Please first install the verification package. exit" 
 export rc=1
 exit
fi


#=====================================
## common machine-dependent parameters
#=====================================
if [ $machine = IBM ]; then
 export vsdbhome=/global/save/wx24fy/VRFY/vsdb         ;#script home, do not change
 export obdata=/climate/save/wx24fy/obdata             ;#observation data for making 2dmaps
 export gstat=/global/shared/stat                      ;#global stats directory              
 export gfsvsdb=/climate/save/wx24fy/VRFY/vsdb_data    ;#operational gfs vsdb database
 export canldir=$gstat/canl                            ;#consensus analysis directory
 export ecmanldir=/global/shared/stat/ecm              ;#ecmwf analysis directory
 export OBSPCP=$gstat/OBSPRCP                          ;#observed precip for verification
 export gfswgnedir=$gstat/wgne1                        ;#operational gfs precip QPF scores
 export gfsfitdir=/climate/save/wx23ss                 ;#Suru operational model fit-to-obs database
 export SUBJOB=$vsdbhome/bin/sub_ibm                   ;#script for submitting batch jobs
 export NWPROD=$vsdbhome/nwprod                        ;#common utilities and libs included in /nwprod
 export GNOSCRUB=/global/noscrub                       ;#archive directory                          
 export STMP=/stmp                                     ;#temporary directory                          
 export PTMP=/ptmp                                     ;#temporary directory                          
 export GRADSBIN=/usrx/local/grads/bin                 ;#GrADS executables       
 export IMGCONVERT=/usrx/local/im_beta/bin/convert     ;#image magic converter
 export FC=/usr/bin/xlf90                              ;#fortran compiler
 export FFLAG=" "                                      ;#fortran compiler options

#----------------------------
elif [ $machine = WCOSS ]; then
 chost=`echo $(hostname) |cut -c 1-1`
 export vsdbhome=/global/save/Fanglin.Yang/VRFY/vsdb        ;#script home, do not change
 export obdata=/global/save/Fanglin.Yang/obdata             ;#observation data for making 2dmaps
 export gstat=/global/noscrub/Fanglin.Yang/stat             ;#global stats directory              
 export gfsvsdb=$gstat/vsdb_data                            ;#operational gfs vsdb database
 export canldir=$gstat/canl                                 ;#consensus analysis directory
 export ecmanldir=$gstat/ecm                                ;#ecmwf analysis directory
 export OBSPCP=$gstat/OBSPRCP                               ;#observed precip for verification
 export gfswgnedir=$gstat/wgne1                             ;#operational gfs precip QPF scores
 export gfsfitdir=/global/save/Suranjana.Saha               ;#Suru operational model fit-to-obs database
 export SUBJOB=$vsdbhome/bin/sub_wcoss                      ;#script for submitting batch jobs
 export NWPROD=$vsdbhome/nwprod                             ;#common utilities and libs included in /nwprod
 export GNOSCRUB=/global/noscrub                            ;#archive directory                          
 export STMP=/stmpd2                                        ;#temporary directory                          
 export PTMP=/ptmpd2                                        ;#temporary directory                          
 export GRADSBIN=/usrx/local/GrADS/2.0.2/bin                ;#GrADS executables       
 export IMGCONVERT=/usrx/local/ImageMagick/6.8.3-3/bin/convert                ;#image magic converter
 export FC=/usrx/local/intel/composer_xe_2011_sp1.11.339/bin/intel64/ifort    ;#intel compiler
 export FFLAG="-O2 -convert big_endian -FR"                 ;#intel compiler options

#----------------------------
elif [ $machine = ZEUS ]; then
 export vsdbhome=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_pkg/vsdb_v17
 export obdata=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/input/plot2d/obdata
 export gstat=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/input/qpf
 export gfsvsdb=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/output/vsdb_data
 export canldir=$gstat/canl                                 ;#consensus analysis directory
 export ecmanldir=$gstat/ecm                                ;#ecmwf analysis directory
 export OBSPCP=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/input/qpf/OBSPRCP
 export gfswgnedir=$gstat/wgne1                             ;#operational gfs precip QPF scores
 export gfsfitdir=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/input/f2o
 export SUBJOB=$vsdbhome/bin/sub_zeus                       ;#script for submitting batch jobs
 export NWPROD=$vsdbhome/nwprod                             ;#common utilities and libs included in /nwprod
 export GNOSCRUB=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/intermediate
 export STMP=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/stmp
 export PTMP=/scratch2/portfolios/NESDIS/h-sandy/noscrub/Deyong.Xu/vsdb_workspace/data/ptmp
#export GRADSBIN=/apps/grads/2.0.1/bin                      ;#GrADS executables       
 export GRADSBIN=/apps/grads/2.0.a9/bin                     ;#GrADS executables       
 export IMGCONVERT=/apps/ImageMagick/ImageMagick-6.7.6-8/bin/convert  ;#image magic converter
 export FC=/apps/intel/composerxe-2011.4.191/composerxe-2011.4.191/bin/intel64/ifort ;#intel compiler
 export FFLAG="-O2 -convert big_endian -FR"                 ;#intel compiler options

#----------------------------
elif [ $machine = BADGER ]; then
 export vsdbhome=/data/dxu/vsdb/vsdb_v17   ;#script home, do not change 
 export obdata=/data/dxu/vsdb/data/input/plot2d/obdata      ;#observation data for making 2dmaps
 export gstat=/data/dxu/vsdb/data/input/qpf    ;#global stats directory 
 export gfsvsdb=/data/dxu/vsdb/data/output/vsdb_data        ;#operational gfs vsdb database
 export canldir=$gstat/canl                                 ;#consensus analysis directory
 export ecmanldir=$gstat/ecm                                ;#ecmwf analysis directory
 export OBSPCP=/data/dxu/vsdb/data/input/qpf/OBSPRCP        ;#observed precip for verification
 export gfswgnedir=$gstat/wgne1                             ;#operational gfs precip QPF scores
 export gfsfitdir=/data/dxu/vsdb/data/input/f2o             ;#Suru operational model fit-to-obs database
 export SUBJOB=$vsdbhome/bin/sub_badger         ;#script for submitting batch jobs
 export NWPROD=$vsdbhome/nwprod                 ;#common utilities and libs included in /nwprod
 export GNOSCRUB=/data/dxu/vsdb/data/intermediate  ;#temporary directory  
 export STMP=/data/users/dxu/vsdb_workspace/data/output/stmp     ;#temporary directory    
 export PTMP=/data/users/dxu/vsdb_workspace/data/output/stmp/ptmp     ;#temporary directory   

 export GRADSBIN=/opt/grads/2.0.1-intel-12.1/bin
 export IMGCONVERT=/usr/bin/convert
 export FC=/opt/intel/composer_xe_2011_sp1.10.319/bin/intel64/ifort
 export FFLAG="-O2 -convert big_endian -FR"

#----------------------------
elif [ $machine = CARDINAL ]; then
 # VSDB home directory
 export vsdbhome=${VSDBHOME}

 # step 1
 export gstat=${ENV_GSTAT}
 export canldir=${ENV_CANLDIR}
 export ecmanldir=${ENV_ECMANLDIR}

 # step 2
 export gfsvsdb=${WORKSPACE}/data/output/vsdb_data

 # step 3
 export OBSPCP=${ENV_OBSPCP}
 export GNOSCRUB=${WORKSPACE}/data/output/conus_prcp

 # step 4 
 # "$gstat/wgne1" used explicitly in script.
 # "$gfswgnedir" is NOT used.
 export gfswgnedir=${gstat}/wgne1

 # step 5
 export gfsfitdir=${ENV_GFSFITDIR}
 export obdata=${ENV_OBDATA}

 # step 6 
 # "$gstat/gfs" used explicitly in script.  

 export STMP=${WORKSPACE}/data/stmp
 export PTMP=${WORKSPACE}/data/ptmp

 export SUBJOB=$vsdbhome/bin/sub_cardinal  
 export NWPROD=$vsdbhome/nwprod           

 export GRADSBIN=/opt/grads/2.0.2-precompiled/bin
 export IMGCONVERT=/usr/bin/convert
 export FC=/opt/intel/composer_xe_2013_sp1.2.144/bin/intel64/ifort
 export FFLAG="-O2 -convert big_endian -FR"

#----------------------------
elif [ $machine = JET ]; then
 export vsdbhome=/pan2/projects/gnmip/Fanglin.Yang/VRFY/vsdb    ;#script home, do not change
 export obdata=/pan2/projects/gnmip/Fanglin.Yang/VRFY/obdata    ;#observation data for making 2dmaps
 export gstat=/pan2/projects/gnmip/Fanglin.Yang/VRFY/stat       ;#global stats directory              
 export gfsvsdb=$gstat/vsdb_data                            ;#operational gfs vsdb database
 export canldir=$gstat/canl                                 ;#consensus analysis directory
 export ecmanldir=$gstat/ecm                                ;#ecmwf analysis directory
 export OBSPCP=$gstat/OBSPRCP                               ;#observed precip for verification
 export gfswgnedir=$gstat/wgne1                             ;#operational gfs precip QPF scores
 export gfsfitdir=$gstat/surufits                           ;#Suru operational model fit-to-obs database
 export SUBJOB=$vsdbhome/bin/sub_jet                        ;#script for submitting batch jobs
 export NWPROD=$vsdbhome/nwprod                             ;#common utilities and libs included in /nwprod
 export GNOSCRUB=/pan2/projects/gnmip/$LOGNAME/noscrub      ;#temporary directory                          
 export STMP=/pan2/projects/gnmip/$LOGNAME/ptmp             ;#temporary directory                          
 export PTMP=/pan2/projects/gnmip/$LOGNAME/ptmp             ;#temporary directory                          
 export GRADSBIN=/opt/grads/2.0.a2/bin                      ;#GrADS executables       
 export IMGCONVERT=/usr/bin/convert                         ;#image magic converter
 export FC=/opt/intel/Compiler/11.1/072//bin/intel64/ifort  ;#intel compiler
 export FFLAG="-O2 -convert big_endian -FR"                 ;#intel compiler options

fi

