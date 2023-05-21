#!/bin/bash

source ./scripts/utils/log2.sh

docs_dir=$1
nodes_dir=$2
proofs_dir=$3

if ! [ -f ./docu_merkle_tree.txt ]
then
    echo -e '\nMerkle Tree Docu Required - Proof Generation Aborted\n'
    echo
    exit 1
fi

ndocs=$(ls ${docs_dir} | wc -l)
levels=$(log2 ndocs)

read -p '- Enter Position of File in Docs Folder: ' target
echo

end=0
file=''

for entry in ${docs_dir}*
do
    if [[ $end == $target ]]
    then
        file=$entry
        echo -e 'Selected File: '${entry}' - node0.'${target}'\n'
        break
    fi
    end=$(($end+1))
done

filename="$(basename $file suffix)"

for (( i=0; i<$levels; i++ ))
do

    if [[ $(($target % 2)) == 0 ]]
    then
        j=$(($target+1))
        if [ -f ${nodes_dir}'node'${i}'.'${j} ]
        then
            p="$(grep -hnr ${i}':'${j}':' ./docu_merkle_tree.txt)"
            echo "${p#*:}" >> ${proofs_dir}'proof_'${filename}
            echo 'Node '${i}'.'${j}' Added to the Proof'
            target=$(($target/2))
        else
            p="$(grep -hnr ${i}':'${target}':' ./docu_merkle_tree.txt)"
            echo "${p#*:}" >> ${proofs_dir}'proof_'${filename}
            echo 'Node '${i}'.'${target}' Added to the Proof'
            target=$(($target/2))
        fi
    else
        j=$(($target-1))
        p="$(grep -hnr ${i}':'${j}':' ./docu_merkle_tree.txt)"
        echo "${p#*:}" >> ${proofs_dir}'proof_'${filename}
        echo 'Node '${i}'.'${j}' Added to the Proof'
        target=$(($j/2))
    fi
done

echo -e '\nProof Document Generated - '${proofs_dir}'proof_'${filename}'\n'