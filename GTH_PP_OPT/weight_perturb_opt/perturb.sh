#! /bin/sh

direc=`pwd`

########################################################################
#Change parameter in this part
conv=0.001
weight_standard='30 2 1'
converg_standard='0.003 0.0003 0.003'
weight_perturb_choice_1='2 5 1'
weight_perturb_choice_2='5 1 2'
weight_perturb_choice_3='2 1 5'
weight_perturb_choice_4='1 5 2'
########################################################################

$direc/optimize.sh $weight_perturb_choice_1 $converge_standard 1
value_1=`$direc/optimize.sh $weight_standard $converge_standard 2`

$direc/optimize.sh $weight_perturb_choice_1 $converge_standard 3 new 2
value_2=`$direc/optimize.sh $weight_standard $converge_standard 4 new 3`

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
$direc/optimize.sh $((weight_perturb_choice_$choice)) $converge_standard $j old $m
((k=base_1+(($i-base_2))*2+2))
value_2=`$direc/optimize.sh $weight_standard $converge_standard $k old $j`
((m=$m+2))
n=$m
echo $k $value_2 >> $direc/$filename

elif [[ `echo "$(echo "scale=4; $value_1 - $value_2" | bc) < $conv" | bc` == 1 ]]; then
if [ choice < 4 ]; then
((choice=$choice+1))
elif [ choice == 12 ]; then
choice=1
fi
if [[ `echo "$echo $value_1 < $value_2" | bc` == 1 ]]; then
value_1=$value_1
((j=base_1+(($i-base_2))*2+1))
((n=$n-2))
$direc/optimize.sh $((weight_perturb_choice_$choice)) $converge_standard $j new $n
((k=base_1+(($i-base_2))*2+2))
value_2=`$direc/optimize.sh $weight_standard $converge_standard $k new $j`
((n=$n+2))
((m=$m+2))

elif [[ `echo "$echo $value_1 < $value_2" | bc` == 0 ]]; then
value_1=$value_2
((j=base_1+(($i-base_2))*2+1))
$direc/optimize.sh $((weight_perturb_choice_$choice)) $converge_standard $j new $m
((k=base_1+(($i-base_2))*2+2))
value_2=`$direc/optimize.sh $weight_standard $converge_standard $k new $j`
((m=$m+2))
n=$m
fi
echo $k $value_2 >> $direc/$filename
fi
