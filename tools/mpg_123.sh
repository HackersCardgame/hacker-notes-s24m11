#! /bin/bash

find /media/marc/77*/Music.merged/ -name "*ardst*" -type f -print0 | shuf -z | xargs -0  mpg123  

