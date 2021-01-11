#! /bin/sh

direc=`pwd`

########################################################################
#Change parameter in this part
conv=0.001
weight_standard='2 5 1'
converge_standard='0.003 0.0003 0.003'
weight_perturb_choice_1='30 2 1'
converge_perturb_choice_1='0.0003 0.00003 0.0003'
converge_perturb_choice_2='0.0002 0.00002 0.0002'
converge_perturb_choice_3='0.0001 0.00001 0.0001'
converge_perturb_choice_4='0.03 0.003 0.03'
converge_perturb_choice_5='0.008 0.0008 0.008'
converge_perturb_choice_6='0.007 0.0007 0.007'
converge_perturb_choice_7='0.006 0.0006 0.006'
converge_perturb_choice_8='0.005 0.0005 0.005'
converge_perturb_choice_9='0.004 0.0004 0.004'
converge_perturb_choice_10='0.0003 0.0003 0.0003'
converge_perturb_choice_11='0.003 0.003 0.003'
converge_perturb_choice_12='0.01 0.01 0.001'
########################################################################

#$direc/optimize.sh "${weight_standard}" "${converge_perturb_choice_1}" 1
value_1=`$direc/optimize.sh "${weight_standard}" "${converge_standard}" 2`

$direc/optimize.sh "${weight_standard}" "${converge_perturb_choice_1}" 3 new 2
value_2=`$direc/optimize.sh "${weight_standard}" "${converge_standard}" 4 new 3`

m=4
n=4
base_1=4
base_2=1
choice=1
filename=mm_1

echo 2 $value_1 >> $direc/$filename
echo 4 $value_2 >> $direc/$filename

for i in {1..2000}
do
if [[ `echo "$(echo "scale=4; $value_1 - $value_2" | bc) > $conv" | bc` == 1 ]]; then
choice=$choice
value_1=$value_2
((j=base_1+(($i-base_2))*2+1))
converge_perturb_new=`eval echo '$'"converge_perturb_choice_$choice"`
$direc/optimize.sh "${weight_standard}" "${converge_perturb_new}" $j old $m
((k=base_1+(($i-base_2))*2+2))
value_2=`$direc/optimize.sh "${weight_standard}" "${converge_standard}" $k old $j`
((m=$m+2))
n=$m
echo $k $value_2 >> $direc/$filename

elif [[ `echo "$(echo "scale=4; $value_1 - $value_2" | bc) < $conv" | bc` == 1 ]]; then
if [ choice < 12 ]; then
((choice=$choice+1))
elif [ choice == 12 ]; then
choice=1
fi
if [[ `echo "$echo $value_1 < $value_2" | bc` == 1 ]]; then
value_1=$value_1
((j=base_1+(($i-base_2))*2+1))
((n=$n-2))
converge_perturb_new=`eval echo '$'"converge_perturb_choice_$choice"`
$direc/optimize.sh "${weight_standard}" "${converge_perturb_new}" $j new $n
((k=base_1+(($i-base_2))*2+2))
value_2=`$direc/optimize.sh "${weight_standard}" "${converge_standard}" $k new $j`
((n=$n+2))
((m=$m+2))

elif [[ `echo "$echo $value_1 < $value_2" | bc` == 0 ]]; then
value_1=$value_2
((j=base_1+(($i-base_2))*2+1))
converge_perturb_new=`eval echo '$'"converge_perturb_choice_$choice"`
$direc/optimize.sh "${weight_standard}" "${converge_perturb_new}" $j new $m
((k=base_1+(($i-base_2))*2+2))
value_2=`$direc/optimize.sh "${weight_standard}" "${converge_standard}" $k new $j`
((m=$m+2))
n=$m
fi
echo $k $value_2 >> $direc/$filename
fi
done
