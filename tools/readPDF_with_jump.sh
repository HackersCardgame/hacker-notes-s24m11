#!/bin/bash

t=$(pdftotext $1 -|tr '\n' ' ')

#echo $t

mark=0
cont=0
count=0

echo F:  $count

handle_sigint() {
  if [ "$count" -gt 3 ]
  then
    exit 1
  else
    echo "killing espeak  ...."
	  first_interrupt=true
	  killall espeak
	  let count=count+1
	  sleep 1
  fi
}

trap 'handle_sigint' SIGINT



IFS='.?!'
read -ra sentences <<< "$t"

echo $sentences

for sentence in "${sentences[@]}"
 do
  echo "$sentence".
  echo
  count=0
  if [[ "$sentence" == *"the reigning world-view was that liberal"* ]];
  then
    mark=1
  fi
  if [ "$mark" == "1"  ]
  then
    speak-ng -v en -s 399 "$sentence"

    wait $!
    #sleep 1
    first_interrupt=false
  fi
  
done
