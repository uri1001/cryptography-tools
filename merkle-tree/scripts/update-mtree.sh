#!/bin/bash

docs_dir=$1
nodes_dir=$2
prefixs_dir=$3
nfiles=$4
levels=$5
sha=$6
file_path=$7

echo -e '--- Updating Merkle Tree ---\n'

nfiles=$(($nfiles-1))

cat ${prefixs_dir}'doc.pre' ${file_path} | openssl dgst -${sha} -binary > ${nodes_dir}'node0.'${nfiles}
echo 'Node data file node0.'${nfiles} 'generated - '${file_path}

echo -e '\nNodes Level 0 Generated (Leaves)\n'

nnodes=$nfiles

for (( i=1; i<=$levels; i++ ))
do

    if [[ $(($nnodes % 2)) == 0 ]]
        then
            nnodes=$(($nnodes/2))
        else
            nnodes=$((($nnodes-1)/2))
    fi

    lag_i=$(($i-1))
    dbl_j=$(($nnodes*2))
    dbl_j_plus=$(((2*$nnodes)+1))

    if [ -f ${nodes_dir}'node'${lag_i}'.'${dbl_j_plus} ]
    then
        cat ${prefixs_dir}'node.pre' ${nodes_dir}'node'${lag_i}.${dbl_j} ${nodes_dir}'node'${lag_i}.${dbl_j_plus} | openssl dgst -${sha} -binary > ${nodes_dir}'node'${i}.${nnodes}
        echo 'Node data file node'${i}.${nnodes}' modified - '${nodes_dir}'node'${lag_i}.${dbl_j}' + '${nodes_dir}'node'${lag_i}.${dbl_j_plus}
    else
        cat ${prefixs_dir}'node.pre' ${nodes_dir}'node'${lag_i}.${dbl_j} | openssl dgst -${sha} -binary > ${nodes_dir}'node'${i}.${nnodes}
        echo 'Node data file node'${i}.${nnodes} 'generated - '${nodes_dir}'node'${lag_i}.${dbl_j}
    fi

    echo -e '\nNodes Level' ${i} 'Generated\n'

done