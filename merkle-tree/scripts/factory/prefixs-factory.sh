#!/bin/bash

prefixs_dir=$1

if [ "$(ls -A ./prefixs/)" ]
then
    read -p 'Change Hash Prefixs (y/n): ' input
    if ! [ $input == 'y' ]
    then
        exit 1
    fi
else
    echo 'Prefixs Need to be Initialized'
fi

if [ -f ${prefixs_dir}doc.pre ]
then
    rm ${prefixs_dir}doc.pre
    rm ${prefixs_dir}node.pre
fi

echo
read -p '- Enter Docs Hash Prefix (do not include \x) : ' input
echo -n -e "\x${input}" >> ${prefixs_dir}doc.pre
output=$(xxd ${prefixs_dir}doc.pre)
echo 'Docs Hash Prefix Set To:' $output

echo
read -p '- Enter Nodes Hash Prefix (do not include \x) : ' input
echo -n -e "\x${input}" >> ${prefixs_dir}node.pre
output=$(xxd ${prefixs_dir}node.pre)
echo 'Nodes Hash Prefix Set To:' $output

exit 1