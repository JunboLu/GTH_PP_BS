#! /bin/sh

for i in {1..129}
do
mkdir step_$i
cp input.inp step_$i
done

for i in {1..100}
do
step_size=`echo "scale=6; 10.1-$i*0.1" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' step_$i/input.inp
done

for i in {101..110}
do
step_size=`echo "scale=6; 0.1-($i-100)*0.01" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' step_$i/input.inp
done

for i in {111..120}
do
step_size=`echo "scale=6; 0.01-($i-110)*0.001" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' step_$i/input.inp
done

for i in {121..129}
do
step_size=`echo "scale=6; 0.001-($i-120)*0.0001" | bc`
sed -ie '36s/.*/    STEP_SIZE  '$step_size'/' step_$i/input.inp
done

