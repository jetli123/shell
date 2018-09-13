#!/bin/bash
cd /home/databases_sql_bak
find . -ctime +30 |xargs rm -f
