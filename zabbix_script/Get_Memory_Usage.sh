#!/bin/bash
GPU_ID=$1
value=$(nvidia-smi |sed -n "/.*${GPU_ID}.*GeForce/{N; s/\n//p}" |awk '{print $20,$22}' |grep -oE [0-9]\{1,\} |sed -n 'N;s/\n/ /p' |awk '{printf("%.2f\n",$1/$2*100)}')
printf "${value:-Unknown}\n"
