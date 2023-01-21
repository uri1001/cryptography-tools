#!/bin/bash

recipient_dir='./recipient/'
sender_dir='./sender/'
public_dir='public/'
private_dir='private/'

mode=$1

valid_selection=false

while [ $valid_selection = false ]
do
  echo '- Select Predefined Diffie-Hellman Standard Group for Key Generation: '
  echo -e '1) Group 1\n2) Group 2\n3) Group 3'
  read -p 'Enter Group Selection: ' group

  case $group in
    1|2|3)
      valid_selection=true
      ;;
    *)
      echo 'Invalid selection'
      ;;
  esac
done

echo -e "Group $group Selected\n"
sleep 1

# Generate Diffie-Hellman group with parameters saved in recipient's public directory
openssl genpkey -genparam -algorithm dhx -pkeyopt dh_rfc5114:$group -out ${recipient_dir}${public_dir}param.pem

echo -e '\nDiffie-Hellam Group Generated from Predefined Standard Group'
echo -e '- Parameters File Saved in Recipient Public Directory -\n'
sleep 1

if [ "$mode" -eq 2 ]
then

    # Generate long-term key pair for recipient and save private key in recipient's private directory
    openssl genpkey -paramfile ${recipient_dir}${public_dir}param.pem -out ${recipient_dir}${private_dir}privkey.pem

    echo -e '\nLong Term Key Pair Generated'
    echo -e '- Private Key Saved in Recipient Private Directory -\n'
    sleep 1

    # Extract public key from private key and save in recipient's public directory
    openssl pkey -in ${recipient_dir}${private_dir}privkey.pem -pubout -out ${recipient_dir}${public_dir}pubkey.pem

    echo -e '\nLong Term Public Key Extracted'
    echo -e '- Public Key Saved in Recipient Public Directory -\n'
    sleep 1
fi

echo -e '\nPublic Directory must be Shared with the other Parties\n'