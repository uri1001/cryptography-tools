#!/bin/bash

docs_dir='./docs/'
nodes_dir='./nodes/'
prefixs_dir='./prefixs/'
proofs_dir='./proofs/'

if ! [[ -d ${docs_dir} ]]
then
    mkdir ${docs_dir}
fi

if ! [[ -d ${nodes_dir} ]]
then
    mkdir ${nodes_dir}
fi

if ! [[ -d ${prefixs_dir} ]]
then
    mkdir ${prefixs_dir}
fi

if ! [[ -d ${proofs_dir} ]]
then
    mkdir ${proofs_dir}
fi

echo -e '\nWelcome to the Merkle Tree Operator\n'

PS3='- Select Option: '
options=('Create Data Files' 'Add Data File' 'Delete Data Files' 'Generate Proof' 'Validate Proof' 'Quit')
select opt in "${options[@]}"
do
    case $opt in
        'Create Data Files')
            echo -e '\nCreate Data Files Selected\n'
            /bin/bash ./scripts/prefixs_factory.sh $prefixs_dir
            /bin/bash ./scripts/docs_factory.sh $docs_dir $nodes_dir $prefixs_dir $proofs_dir Create
            /bin/bash ./scripts/nodes_factory.sh $docs_dir $nodes_dir $prefixs_dir Create
            echo
            exit 1
            ;;
        'Add Data File')
            echo -e '\nCreate Data Files Selected\n'
            /bin/bash ./scripts/prefixs_factory.sh $prefixs_dir
            /bin/bash ./scripts/docs_factory.sh $docs_dir $nodes_dir $prefixs_dir $proofs_dir Add
            read -p '- Enter Absolute Path of File to Add to Docs : ' path
            echo
            cp $path ./docs/
            echo -e 'File Copied to Docs Directory'
            /bin/bash ./scripts/nodes_factory.sh $docs_dir $nodes_dir $prefixs_dir Add $path
            echo
            exit 1
            ;;
        'Delete Data Files')
            echo -e '\nDelete Data Files Selected\n'
            /bin/bash ./scripts/prefixs_factory.sh $prefixs_dir
            /bin/bash ./scripts/docs_factory.sh $docs_dir $nodes_dir $prefixs_dir $proofs_dir Delete
            /bin/bash ./scripts/nodes_factory.sh $docs_dir $nodes_dir $prefixs_dir Delete
            echo
            exit 1
            ;;
        'Generate Proof')
            echo -e '\nGenerate Proof from Selected Leaf'
            echo
            /bin/bash ./scripts/proofs_factory.sh $docs_dir $nodes_dir $proofs_dir
            exit 1
            ;;
        'Validate Proof')
            echo -e '\nValidate Proof from Selected Leaf'
            echo
            /bin/bash ./scripts/proofs_validate.sh $docs_dir $nodes_dir $prefixs_dir $proofs_dir
            exit 1
            ;;
        'Quit')
            echo
            exit 1
            ;;
        *) echo 'invalid option $REPLY';;
    esac
done