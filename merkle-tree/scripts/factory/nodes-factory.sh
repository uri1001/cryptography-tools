#!/bin/bash

source ./scripts/utils/log2.sh

docs_dir=$1
nodes_dir=$2
prefixs_dir=$3
comm=$4
file_path=$5

nfiles=$(ls ${docs_dir} | wc -l)

levels=$(log2 nfiles)

echo -e '\nNumber of Data Files: '${nfiles}

if [ $nfiles == 0 ]
then
    echo
    exit 1
fi

echo -e '\nMerkle Tree Number of Levels: '$(($levels+1))'\n'

read -p 'Enter SHA Algorithm (sha1/sha224/sha256/sha384/sha512): ' sha
echo

if [ $comm == 'Add' ] && [ -f ./docu_merkle_tree.txt ]
then
    read -p 'Create or Update New Merkle Tree (update/create): ' input
    echo
    if [ $input == 'update' ]
    then
        /bin/bash ./scripts/update-mtree.sh $docs_dir $nodes_dir $prefixs_dir $nfiles $levels $sha $file_path
        /bin/bash ./scripts/factory/docu-factory.sh $docs_dir $nodes_dir $prefixs_dir $nfiles $levels $sha
        exit 1
    fi
fi

/bin/bash ./scripts/create-mtree.sh $docs_dir $nodes_dir $prefixs_dir $nfiles $levels $sha
/bin/bash ./scripts/factory/docu-factory.sh $docs_dir $nodes_dir $prefixs_dir $nfiles $levels $sha