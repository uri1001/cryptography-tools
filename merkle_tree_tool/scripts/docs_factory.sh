#!/bin/bash

docs_dir=$1
nodes_dir=$2
prefixs_dir=$3
proofs_dir=$4
comm=$5

start=0

if [ "$(ls -A $docs_dir)" ]
then
    start=$(ls ${docs_dir} | wc -l)
else
    if [ $comm == 'Delete' ]
    then
        echo -e '\nDirectory Empty - Delete Operation Aborted\n'
        exit 1
    fi
fi

echo -e '\nDocs Directory Contains' $start 'Data Files\n'

if [ $comm == 'Add' ]
then
    exit 1
fi

read -p '- Enter Number of Files to '${comm}' : ' target
echo

if [ $comm == 'Create' ]
then
    end=$(($start+$target))
    for (( i=$start; i<$end; i++ ))
    do
        openssl rand -hex 32 | cat >> ${docs_dir}doc$i.dat
        echo 'File' doc$i.dat 'generated with random data'
    done
else
    end=0

    for file in ${docs_dir}*
    do
        rm ${file}
        end=$(($end+1))
        echo 'File' ${file} 'has been deleted'
        
        if [[ $end == $target ]]
        then
            break
        fi
    done

    rm './docu_merkle_tree.txt'
    rm './graph_merkle_tree.txt'
    rm ${nodes_dir}*

    if [ "$(ls -A $proofs_dir)" ]
    then
       rm ${proofs_dir}*
    fi

    if ! [ "$(ls -A $docs_dir)" ]
    then
        echo -e '\nAll Files Removed - Node, Docu & Proof Files Deleted'
    else
         echo -e '\nSelected Files Removed - Node, Docu & Proof Files Deleted'
    fi
fi