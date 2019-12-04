#! /bin/sh

direc=`pwd`
parallel_num=40
run_start=1
run_end=40
export CP2K_EXE_DIR=/home/lijun/lujb/bin/cp2k-6.1
export ELEM=Am
export ELEC_NUM=17

produce() {
x=$1
direc=$2
cd $direc/step_$x
$CP2K_EXE_DIR/cp2k-6.1-Linux-x86_64.sopt input.inp 1> qmmm.out 2> qmmm.err
sed -ie '1s/.*/'$ELEM' GTH-PBE-q'$ELEC_NUM'/' GTH-PARAMETER

export -f produce

seq $run_start $run_end | parallel -j $parallel_num produce {} $direc
