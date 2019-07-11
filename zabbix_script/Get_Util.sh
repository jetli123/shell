#!/bin/bash
GPU_ID=$1
value=$(nvidia-smi |sed -n "/.*${GPU_ID}.*GeForce/{N; s/\n//p}" |awk '{print $24}' |cut -d % -f1)
printf "${value:-Unknown}\n"
