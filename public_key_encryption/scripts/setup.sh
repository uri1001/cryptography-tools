#!/bin/bash

recipient_dir='./recipient/'
sender_dir='./sender/'
public_dir='public/'
private_dir='private/'

mode=$1

if ! [[ -d ${recipient_dir} ]]
then
    mkdir ${recipient_dir}
    mkdir ${recipient_dir}${public_dir}
    mkdir ${recipient_dir}${private_dir}
fi

if ! [[ -d ${recipient_dir}${private_dir} ]]
then
    mkdir ${recipient_dir}${private_dir}
fi

if ! [[ -d ${recipient_dir}${public_dir} ]]
then
    mkdir ${recipient_dir}${public_dir}
fi

if ! [[ -d ${sender_dir} ]]
then
    mkdir ${sender_dir}
    mkdir ${sender_dir}${public_dir}
    mkdir ${sender_dir}${private_dir}
fi

if ! [[ -d ${sender_dir}${private_dir} ]]
then
    mkdir ${sender_dir}${private_dir}
fi

if ! [[ -d ${sender_dir}${public_dir} ]]
then
    mkdir ${sender_dir}${public_dir}
fi

if [ "$mode" -eq 1 ]
then
    echo -e '\nTo Continue with Encryption Process the Recipient Encryption Public Key is Required'
    echo -e '- pubkey.pem File Must Be Placed in the Recipient Public Directory -\n'
    sleep 1

    while true
    do
        read -p 'Press enter when the file has been added: '

        if [ -f ${recipient_dir}${public_dir}'pubkey.pem' ]
        then
            echo 'Recipient Public Key File Found'
            echo -e '\n- Recipient Public Key File Start -\n'
            echo "$(cat "${recipient_dir}${public_dir}pubkey.pem")"
            echo -e '\n- Recipient Public Key File End -\n'
            sleep 1
            break
        else
            echo -e 'Error: the file could not be found. Please make sure it has been placed in the correct directory.\n'
        fi
    done
fi

if [ "$mode" -eq 2 ]; then
    echo -e '\nTo Continue with Decryption Process the Recipient Decryption Private Key is Required'
    echo -e '- privkey.pem File Must Be Placed in the Recipient Private Directory -\n'
    sleep 1

    while true
    do
        read -p 'Press enter when the file has been added: '

        if [ -f ${recipient_dir}${private_dir}'privkey.pem' ]
        then
            echo 'Recipient Private Key File Found'
            echo -e '\n- Recipient Private Key File Start -\n'
            echo "$(cat "${recipient_dir}${private_dir}privkey.pem")"
            echo -e '\n- Recipient Private Key File End -\n'
            sleep 1
            break
        else
            echo -e 'Error: the file could not be found. Please make sure it has been placed in the correct directory.\n'
        fi
    done
fi

if [ "$mode" -eq 1 ] || [ "$mode" -eq 3 ]; then
    echo -e '\nTo Continue with Encryption Process the Sender Data File is Required'
    echo -e '- data.txt File Must Be Placed in the Sender Directory -\n'
    sleep 1

    while true
    do
        read -p 'Press enter when the file has been added: '

        if [ -f ${sender_dir}'data.txt' ]
        then
            echo 'Sender Data File Found'
            break
        else
            echo -e 'Error: the file could not be found. Please make sure it has been placed in the correct directory.\n'
        fi
    done

    echo -e '\n- Data File Start -\n'
    echo -e "`cat ./sender/data.txt | head -n 7`"
    echo -e '\n- Data File End -\n'
    sleep 1
fi

if [ "$mode" -eq 2 ]; then
    echo -e '\nTo Continue with Decryption Process the Sender Complete Ciphertext File is Required'
    echo -e '- complete_ciphertext.pem File Must Be Placed in the Sender Public Directory -\n'
    sleep 1

    while true
    do
        read -p 'Press enter when the file has been added: '

        if [ -f ${sender_dir}${public_dir}'complete_ciphertext.pem' ]
        then
            echo 'Sender Complete Ciphertext File Found'
            break
        else
            echo -e 'Error: the file could not be found. Please make sure it has been placed in the correct directory.\n'
        fi
    done

    echo -e '\n- Complete Ciphertext File Start -\n'
    echo "$(cat ./sender/public/complete_ciphertext.pem)"
    echo -e '\n- Complete Ciphertext File End -\n'
    sleep 1
fi