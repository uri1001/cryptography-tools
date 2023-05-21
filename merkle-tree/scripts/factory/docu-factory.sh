#!/bin/bash

docs_dir=$1
nodes_dir=$2
prefixs_dir=$3
nfiles=$4
levels=$5
sha=$6

graph_docu=''
txt_docu=''
k=0

for entry in ${docs_dir}*
do
    graph_docu+='0.'${k}'-'$(cat ${nodes_dir}'node0.'${k} | xxd -p | tr -d '[:space:]')' '
    txt_docu+='0:'${k}':'$(cat ${nodes_dir}'node0.'${k} | xxd -p | tr -d '[:space:]')'\n'
    k=$(($k+1))
done

nnodes=$nfiles
odd=false
graph_docu+='\n'

for (( i=1; i<=$levels; i++ ))
do

    if [[ $(($nnodes % 2)) == 0 ]]
    then
        nnodes=$(($nnodes/2))
    else
        nnodes=$((($nnodes+1)/2))
    fi

    for (( j=0; j<$nnodes; j++ ))
    do

        graph_docu+=${i}'.'${j}'-'$(cat ${nodes_dir}'node'${i}.${j} | xxd -p | tr -d '[:space:]')' '
        txt_docu+=${i}':'${j}':'$(cat ${nodes_dir}'node'${i}.${j} | xxd -p | tr -d '[:space:]')'\n'

    done

    graph_docu+='\n'

done

doc_pre=$(cat ${prefixs_dir}doc.pre | xxd -p)
node_pre=$(cat ${prefixs_dir}node.pre | xxd -p)
txt_docu='MerkleTree:'$sha':'$doc_pre':'$node_pre':'${nfiles}':'$(($levels+1))':'$(cat ${nodes_dir}'node'${levels}.'0' | xxd -p | tr -d '[:space:]')'\n'$txt_docu

if [ -f ./graph_merkle_tree.txt ]
then
    rm ./graph_merkle_tree.txt
    rm ./docu_merkle_tree.txt
fi

echo -ne $graph_docu > ./graph_merkle_tree.txt
echo -ne $txt_docu > ./docu_merkle_tree.txt
echo -e 'Merkle Tree Graphic & Text Documents Generated'