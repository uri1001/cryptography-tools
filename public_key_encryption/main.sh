#!/bin/bash

recipient_dir='./recipient/'
sender_dir='./sender/'
public_dir='public/'
private_dir='private/'

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

echo -e '\nWelcome to the Public Key Encryption Operator\n'

valid_selection=false

while [ $valid_selection = false ]; do
  echo '- Select Operator Execution Mode: '
  echo -e '1) Encrypt Data With External Public Key\n2) Decrypt Data With External Private Key\n3) Encrypt and Decrypt Data'
  read -p 'Enter Mode Selection: ' mode

  case $mode in
    1)
      echo -e '\nEncrypt Data With External Public Key Mode Selected\n'
      valid_selection=true
      ;;
    2)
      echo -e '\nDecrypt Data With External Private Key Mode Selected\n'
      valid_selection=true
      ;;
    3)
      echo -e '\nEncrypt and Decrypt Data Mode Selected\n'
      valid_selection=true
      ;;
    *)
      echo 'Invalid selection'
      ;;
  esac
done

/bin/bash ./scripts/setup.sh $mode

if [ "$mode" -eq 1 ] || [ "$mode" -eq 3 ]; then
  /bin/bash ./scripts/param_and_key_gen.sh $mode

  while true; do
    read -p 'Continue with the encryption process? (y/n)' answer

    if [ "$answer" == "y" ]; then
      echo -e '\n\n--- Encryption Process Initialized ---\n'
      break
    elif [ "$answer" == "n" ]; then
      echo -e '\nOperator Terminated\n'
      exit
    else
      echo "Invalid answer, please enter y or n."
    fi
  done

  sleep 1

  /bin/bash ./scripts/pubkey_enc.sh
fi

if [ "$mode" -eq 2 ] || [ "$mode" -eq 3 ]; then
  while true; do
    read -p 'Continue with the dencryption process? (y/n)' answer

    if [ "$answer" == "y" ]; then
      echo -e '\n\n--- Decryption Process Initialized ---\n'
      break
    elif [ "$answer" == "n" ]; then
      echo -e '\nOperator Terminated\n'
      exit
    else
      echo "Invalid answer, please enter y or n."
    fi
  done

  sleep 1

  /bin/bash ./scripts/pubkey_dec.sh
fi

echo -e '\nOperator Terminated\n'