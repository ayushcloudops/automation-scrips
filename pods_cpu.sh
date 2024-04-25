#!/bin/sh

pods=(`kubectl top pods --all-namespaces | awk '{ print $2 }'`)
for pcu in ${pods[@]}
do
    echo $pcu
done