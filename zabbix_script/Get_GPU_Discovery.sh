#!/bin/bash
value=$(gpu_num=$(nvidia-smi |sed -n '/.*GeForce/{N; s/\n//p}' |awk '{print $2}'); echo -n '{"data":['; for i in $gpu_num; do echo -n "{\"{#GPU_ID}\": \"$i\"},"; done |sed -e 's:\},$:\}:'; echo -n ']}';)
printf "${value:-Unknown}"
