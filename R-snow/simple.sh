#!/bin/bash
export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin

mkdir rLibs

Rscript -e "parallel:::.slaveRSOCK()" MASTER=$2 PORT=$3 OUT=$1.log TIMEOUT=2592000 METHODS=TRUE XDR=TRUE 
