#!/bin/bash

recipient_dir='./recipient/'
sender_dir='./sender/'
public_dir='public/'
private_dir='private/'

complete_ciphertext_path="${sender_dir}${public_dir}complete_ciphertext.pem"

echo -e '- Complete Ciphertext File Start -\n'
echo "$(cat "${complete_ciphertext_path}")"
echo -e '\n- Complete Ciphertext File End -\n'
sleep 1

# Unformat complete ciphertext to extract ephemeral public key, IV, ciphertext, and tag
awk '/-----BEGIN PUBLIC KEY-----/,/-----END PUBLIC KEY-----/' "${complete_ciphertext_path}" > ${recipient_dir}${public_dir}ephpubkey.pem
openssl enc -d -a -in <(awk '/-----BEGIN AES-128-CBC IV-----/,/-----END AES-128-CBC IV-----/' "${complete_ciphertext_path}") > ${recipient_dir}${public_dir}iv.bin
openssl enc -d -a -in <(awk '/-----BEGIN AES-128-CBC CIPHERTEXT-----/,/-----END AES-128-CBC CIPHERTEXT-----/' "${complete_ciphertext_path}") > ${recipient_dir}${public_dir}ciphertext.bin
openssl enc -d -a -in <(awk '/-----BEGIN SHA256-HMAC TAG-----/,/-----END SHA256-HMAC TAG-----/' "${complete_ciphertext_path}") > ${recipient_dir}${public_dir}tag.bin

echo -e '\nComplete Ciphertext Unformatted'
echo -e '- Ephemeral Public Key, IV, Ciphertext and Tag Files Saved in Recipient Public Directory -\n'
sleep 1

# Generate common secret using recipient's long-term private key and sender's ephemeral public key, saving common secret in recipient's private directory
openssl pkeyutl -derive -inkey ${recipient_dir}${private_dir}privkey.pem -peerkey ${recipient_dir}${public_dir}ephpubkey.pem -out ${recipient_dir}${private_dir}commsecret.pem

echo -e '\nCommon Secret Recovered'
echo -e '- Common Secret File Saved in Recipient Private Directory -\n'
sleep 1

# Generate encryption and hash keys from common secret and save in recipient's private directory
cat ${recipient_dir}${private_dir}commsecret.pem | openssl dgst -sha256 -binary | head -c 16 | xxd -p > ${recipient_dir}${private_dir}enckey
cat ${recipient_dir}${private_dir}commsecret.pem | openssl dgst -sha256 -binary | tail -c 16 | xxd -p > ${recipient_dir}${private_dir}hashkey

echo -e '\nEncryption and Hash Keys Generated From Common Secret'
echo -e '- Key Files Saved in Recipient Private Directory -\n'
sleep 1

# Compute hash tag of received message and challenge against received hash tag
cat ${recipient_dir}${public_dir}iv.bin ${recipient_dir}${public_dir}ciphertext.bin | openssl dgst -hmac -sha256 -binary -macopt hexkey:$(cat ${recipient_dir}${private_dir}hashkey) > ${recipient_dir}${public_dir}recvtag.bin
cmp ${recipient_dir}${public_dir}tag.bin ${recipient_dir}${public_dir}recvtag.bin || (echo "Error: HMAC does not match" && exit 1)

echo -e '\nRecipient Side Tag Computed'
echo -e '- Recipient Side Tag Saved in Recipient Private Directory -\n'
echo -e '\nSender and Recipient Hash Tags Are Equal\n'
sleep 1

# Decrypt data file using AES-128 in CBC mode with the generated encryption key and received IV, saving encrypted file in recipient's public directory
openssl enc -d -aes-128-cbc -in ${recipient_dir}${public_dir}ciphertext.bin -out ${recipient_dir}data.txt -K $(cat ${recipient_dir}${private_dir}enckey) -iv $(cat ${recipient_dir}${public_dir}iv.bin)

echo -e '\nCiphertext Decryption Finalized\n'
echo -e '- Data File Saved in Recipient Directory -\n'

echo -e '\n- Decrypted Data File Start -\n'
echo -e "`cat ./recipient/data.txt | head -n 7`"
echo -e '\n- Decrypted Data File End -\n'
sleep 1