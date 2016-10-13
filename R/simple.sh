#!/bin/bash
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

./unzip packages.zip

mkdir rLibs

Rscript $1 $2

rm *.nc
rm glm2.nml
rm overflow.csv
rm lake.csv
rm stress_dbg.csv
