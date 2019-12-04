#! /bin/sh

direc=`pwd`

########################################################################
#Change parameter in this part
conv=0.001
weight_standard='30 2 1'
converg_standard='0.003 0.0003 0.003'
########################################################################

value_1=`$direc/optimize.sh $weight_standard $converge_standard 1`
value_2=`$direc/optimize.sh $weight_standard $converge_standard 2`

echo 1 $value_1 >> $direc/$filename
echo 2 $value_2 >> $direc/$filename

m=2
n=2

for i in {3..2000}
do
if [[ `echo "$(echo "scale=4; $value_1 - $value_2" | bc) > $conv" | bc` == 1 ]]; then
value_1=$value_2
value_2=`$direc/optimize.sh $weight_standard $converge_standard $i old $m`
((m=$m+1))
n=$m
echo $i $value_2 >> $direc/$filename

elif [[ `echo "$(echo "scale=4; $value_1 - $value_2" | bc) < $conv" | bc` == 1 ]]; then
if [[ `echo "$echo $value_1 < $value_2" | bc` == 1 ]]; then
value_1=$value_1
((n=$n-1))
value_2=`$direc/optimize.sh $weight_standard $converge_standard $i new $n`
((n=$n+1))
((m=$m+1))

elif [[ `echo "$echo $value_1 < $value_2" | bc` == 0 ]]; then
value_1=$value_2
value_2=`$direc/optimize.sh $weight_standard $converge_standard $i new $m`
((m=$m+1))
n=$m
fi
echo $i $value_2 >> $direc/$filename
fi
