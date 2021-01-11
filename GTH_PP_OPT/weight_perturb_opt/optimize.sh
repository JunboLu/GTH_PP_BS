#! /bin/sh

direc=`pwd`
initial_total_step=20
normal_total_step=11
initial_parallel_num=20
normal_parallel_num=11

weight_semi=$1
weight_val=$2
weight_vir=$3

conv_semi=$4
conv_val=$5
conv_vir=$6

i=$7
check_direc=$8
kk=$9

mkdir $direc/restart$i
cp $direc/get_index.py $direc/restart$i
if [[ $i == 1 || $i == 2 || $check_direc == new ]]; then
for j in $(seq 1 $initial_total_step)
do
mkdir $direc/restart$i/step_$j
cp $direc/input.inp $direc/restart$i/step_$j
done
for j in $(seq 1 10)
do
step_size=`echo "scale=6; 0.011-$j*0.001" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' $direc/restart$i/step_$j/input.inp
done
for j in $(seq 11 19)
do
step_size=`echo "scale=6; 0.001-($j-10)*0.0001" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' $direc/restart$i/step_$j/input.inp
done
sed -ie '36s/.*/    STEP_SIZE  0.00009/' $direc/restart$i/step_20/input.inp
fi
if [[ $i != 1 && $i != 2 && $check_direc == old ]]; then
for j in $(seq 1 $normal_total_step)
do
mkdir $direc/restart$i/step_$j
cp $direc/input.inp $direc/restart$i/step_$j
done
fi

sed -ie '45s/.*/     WEIGHT_POT_SEMICORE               '$weight_semi'/' $direc/restart$i/step*/input.inp
sed -ie '46s/.*/     WEIGHT_POT_VALENCE                '$weight_val'/' $direc/restart$i/step*/input.inp
sed -ie '47s/.*/     WEIGHT_POT_VIRTUAL                '$weight_vir'/' $direc/restart$i/step*/input.inp
sed -ie '41s/.*/     TARGET_POT_SEMICORE      [eV]      '$conv_semi'/' $direc/restart$i/step*/input.inp
sed -ie '42s/.*/     TARGET_POT_VALENCE       [eV]      '$conv_val'/' $direc/restart$i/step*/input.inp
sed -ie '43s/.*/     TARGET_POT_VIRTUAL       [eV]      '$conv_vir'/' $direc/restart$i/step*/input.inp
rm $direc/restart$i/step*/*e

if [[ $i == 1 || $kk == 0 ]]; then
for j in $(seq 1 $initial_total_step)
do
sed -ie '29s/.*/    POTENTIAL_FILE_NAME  ..\/..\/GTH-PARAMETER/' $direc/restart$i/step_$j/input.inp
done
produce() {
x=$1
y=$2
direc=$3
cd $direc/restart$y/step_$x
/home/lujb/bin/cp2k-6.1/cp2k-6.1-Linux-x86_64.sopt input.inp 1> qmmm.out 2> qmmm.err
}
export -f produce
seq 1 $initial_total_step | parallel -j $initial_parallel_num produce {} $i $direc

elif [[ $i == 2 || $kk == 1 ]]; then
((k=$i-1))
cd $direc/restart$k
grep "Final value of function" step*/qm* > kk
m=`python2.7 -c 'import get_index; print get_index.get_index()'`
sed -ie '1s/.*/Am GTH-PBE-q17/' step_$m/GTH-PARAMETER
for j in $(seq 1 $initial_total_step)
do
sed -ie '29s/.*/    POTENTIAL_FILE_NAME  ..\/..\/restart'$k'\/step_'$m'\/GTH-PARAMETER/' $direc/restart$i/step_$j/input.inp
done
produce() {
x=$1
y=$2
direc=$3
cd $direc/restart$y/step_$x
/home/lujb/bin/cp2k-6.1/cp2k-6.1-Linux-x86_64.sopt input.inp 1> qmmm.out 2> qmmm.err
}
export -f produce
seq 1 $initial_total_step | parallel -j $initial_parallel_num produce {} $i $direc

elif [[ $i != 1 && $i != 2 ]]; then
k_1=$kk
cd $direc/restart$k_1
grep "Final value of function" step*/qm* > kk
m=`python2.7 -c 'import get_index; print get_index.get_index()'`
sed -ie '1s/.*/Am GTH-PBE-q17/' step_$m/GTH-PARAMETER
if [ $check_direc == new ]; then
total_step=$initial_total_step
elif [ $check_direc == old ]; then
total_step=$normal_total_step
fi
for j in $(seq 1 $total_step)
do
sed -ie '29s/.*/    POTENTIAL_FILE_NAME  ..\/..\/restart'$k_1'\/step_'$m'\/GTH-PARAMETER/' $direc/restart$i/step_$j/input.inp
done
if [ $check_direc == old ]; then
((k_2=$kk-1))
cd $direc/restart$k_2
grep "Final value of function" step*/qm* > kk
m=`python2.7 -c 'import get_index; print get_index.get_index()'`
a=`sed -n '36p' step_$m/input.inp`
step_size_pre=`echo $a | tr -cd "[0-9,.]"`
for j in $(seq 1 $total_step)
do
scalling=`echo "scale=6; 0.4+0.1*$j" | bc`
step_size=`echo "scale=6; $step_size_pre*$scalling" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' $direc/restart$i/step_$j/input.inp
done
fi
produce() {
x=$1
y=$2
direc=$3
cd $direc/restart$y/step_$x
/home/lujb/bin/cp2k-6.1/cp2k-6.1-Linux-x86_64.sopt input.inp 1> qmmm.out 2> qmmm.err
}
export -f produce
if [ $check_direc == new ]; then
parallel_num=$initial_parallel_num
elif [ $check_direc == old ]; then
parallel_num=$normal_parallel_num
fi
seq 1 $total_step | parallel -j $parallel_num produce {} $i $direc
fi

cd $direc/restart$i
for z in {1..20}; do grep "Final value of function" step_$z/qm*; done > kk
m=`python2.7 -c 'import get_index; print get_index.get_index()'`
str=`sed -n ''$m'p' kk`
value=`echo ${str:20:100} | tr -cd "[0-9,.]"`
echo $value
cd $direc
