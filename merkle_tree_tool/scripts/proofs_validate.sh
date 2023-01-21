#!/bin/bash

docs_dir=$1
nodes_dir=$2
prefixs_dir=$3
proofs_dir=$4

if ! [ -f ./docu_merkle_tree.txt ]
then
    echo -e '\nMerkle Tree Docu Required - Proof Validation Aborted\n'
    echo
    exit 1
fi

read -p '- Enter Filename of Proof File to Validate (with extension) : ' filename

echo -e '\nNote Existing Prefixs Files Will Be Used to Compute Proof Validation\n'

root=$(tail -1 ./docu_merkle_tree.txt)
root="${root##*:}"

sha=$(head -n 1 ./docu_merkle_tree.txt)
sha=${sha#"MerkleTree:"}
sha=${sha%%:*}

echo -e 'Merkle Tree Route to Validate: '${root}'\n'

doc="${filename##*'proof_'}"
z=0

cat ${prefixs_dir}'doc.pre' ${docs_dir}${doc} | openssl dgst -${sha} -binary > ./computed_hash_${z}

echo 'Level '${z}' Proof Validation Computed'

while read l
do
    declare -i i="${l%%:*}"
    x="${l%:*}"
    declare -i j="${x##*:}"
    declare -i j_p=$(($j+1))
    z_p=$(($z+1))

    if [[ $(($j % 2)) == 0 ]]
    then
        if ! [ -f ${nodes_dir}'node'${i}.${j_p} ]
        then
            cat ${prefixs_dir}'node.pre' ${nodes_dir}'node'${i}.${j} | openssl dgst -${sha} -binary > ./computed_hash_${z_p}
            echo 'Level '${i}' Proof Validation Computed - node'${i}.${j}
        else
            cat ${prefixs_dir}'node.pre' ${nodes_dir}'node'${i}.${j} ./computed_hash_${z} | openssl dgst -${sha} -binary > ./computed_hash_${z_p}
            echo 'Level '${i}' Proof Validation Computed - node'${i}.${j}' + last computed hash'
        fi
    else
        cat ${prefixs_dir}'node.pre' ./computed_hash_${z} ${nodes_dir}'node'${i}.${j} | openssl dgst -${sha} -binary > ./computed_hash_${z_p}
        echo 'Level '${i}' Proof Validation Computed - last computed hash + node'${i}.${j}
    fi
    z=$(($z+1))
done < ${proofs_dir}${filename}

res=$(xxd -p ./computed_hash_${z} | tr -d '[:space:]')

echo -e '\nResulting Computed Hash: '${res}

if [ $res == $root ]
then
    echo -e '\nProof Validation Result: Success\n'
else
    echo -e '\nProof Validation Result: Failure\n'
fi

for ((i=0; i<=$z; i++))
do
    rm ./computed_hash_${i}
done