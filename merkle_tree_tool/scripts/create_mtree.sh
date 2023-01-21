#!/bin/bash

docs_dir=$1
nodes_dir=$2
prefixs_dir=$3
nfiles=$4
levels=$5
sha=$6

echo -e '--- Creating New Merkle Tree ---\n'

k=0

for entry in ${docs_dir}*
do
    cat ${prefixs_dir}'doc.pre' ${entry} | openssl dgst -${sha} -binary > ${nodes_dir}'node0.'${k}
    echo 'Node data file node0.'${k} 'generated - '${entry}
    k=$(($k+1))
done

echo -e '\nNodes Level 0 Generated (Leaves)\n'

nnodes=$nfiles
odd=false

for (( i=1; i<=$levels; i++ ))
do

    if [[ $(($nnodes % 2)) == 0 ]]
    then
        nnodes=$(($nnodes/2))
    else
        nnodes=$((($nnodes+1)/2))
        odd=true
    fi

    for (( j=0; j<$nnodes; j++ ))
    do

        lag_i=$(($i-1))
        dbl_j=$(($j*2))
        dbl_j_plus=$(((2*$j)+1))

        if $odd && [ $j == $(($nnodes-1)) ] && [ $nnodes != 1 ]
        then
            cat ${prefixs_dir}'node.pre' ${nodes_dir}'node'${lag_i}.${dbl_j} | openssl dgst -${sha} -binary > ${nodes_dir}'node'${i}.${j}
            echo 'Node data file node'${i}.${j} 'generated - '${nodes_dir}'node'${lag_i}.${dbl_j}
        else
            cat ${prefixs_dir}'node.pre' ${nodes_dir}'node'${lag_i}.${dbl_j} ${nodes_dir}'node'${lag_i}.${dbl_j_plus} | openssl dgst -${sha} -binary > ${nodes_dir}'node'${i}.${j}
            echo 'Node data file node'${i}.${j} 'generated - '${nodes_dir}'node'${lag_i}.${dbl_j}' + '${nodes_dir}'node'${lag_i}.${dbl_j_plus}
        fi

    done

    echo -e '\nNodes Level' ${i} 'Generated\n'

done