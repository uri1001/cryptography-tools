#!/bin/bash

recipient_dir='./recipient/'
sender_dir='./sender/'
public_dir='public/'
private_dir='private/'

# Generate ephemeral Diffie-Hellman keypair for sender and save keypair in sender's private directory
openssl genpkey -paramfile ${recipient_dir}${public_dir}param.pem -out ${sender_dir}${private_dir}ephkeypair.pem

echo -e '\nEphemeral Diffie-Hellman Keypair Generated'
echo -e '- Keypair File Saved in Sender Private Directory -\n'
sleep 1

# Extract public key from ephemeral keypair and save in sender's public directory
openssl pkey -in ${sender_dir}${private_dir}ephkeypair.pem -pubout -out ${sender_dir}${public_dir}ephpubkey.pem

echo -e '\nEphemeral Public Key File Generated'
echo -e '- Public Key File Saved in Sender Public Directory -\n'
sleep 1

# Extract private key from ephemeral keypair and save in sender's private directory
openssl pkey -in ${sender_dir}${private_dir}ephkeypair.pem -out ${sender_dir}${private_dir}ephprivkey.pem

echo -e '\nEphemeral Private Key File Generated'
echo -e '- Private Key File Saved in Sender Private Directory -\n'
sleep 1

# Generate common secret using sender's ephemeral private key and recipient's long-term public key, saving common secret in sender's private directory
openssl pkeyutl -inkey ${sender_dir}${private_dir}ephprivkey.pem -peerkey ${recipient_dir}${public_dir}pubkey.pem -derive -out ${sender_dir}${private_dir}commsecret.pem

echo -e '\nCommon Secret Derived'
echo -e '- Common Secret File Saved in Sender Private Directory -\n'
sleep 1

# Generate encryption and hash keys from common secret and save in sender's private directory
cat ${sender_dir}${private_dir}commsecret.pem | openssl dgst -sha256 -binary | head -c 16 | xxd -p > ${sender_dir}${private_dir}enckey
cat ${sender_dir}${private_dir}commsecret.pem | openssl dgst -sha256 -binary | tail -c 16 | xxd -p > ${sender_dir}${private_dir}hashkey

echo -e '\nEncryption and Hash Key Files Generated from Common Secret'
echo -e '- Key Files Saved in Sender Private Directory -\n'
sleep 1

# Generate initialization vector (IV) for AES encryption and save in sender's public directory
openssl rand 16 | xxd -p > ${sender_dir}${public_dir}iv.bin

# Encrypt data file using AES-128 in CBC mode with the generated encryption key and IV, saving encrypted file in sender's public directory
openssl enc -aes-128-cbc -K $(cat ${sender_dir}${private_dir}enckey) -iv $(cat ${sender_dir}${public_dir}iv.bin) -in ${sender_dir}data.txt -out ${sender_dir}${public_dir}ciphertext.bin

# Generate data tag using the generated hash key and save in sender's public directory
cat ${sender_dir}${public_dir}iv.bin ${sender_dir}${public_dir}ciphertext.bin | openssl dgst -hmac -sha256 -binary -macopt hexkey:$(cat ${sender_dir}${private_dir}hashkey) -binary > ${sender_dir}${public_dir}tag.bin

echo -e '\nEncrypted Text and Data Tag from Data Generated'
echo -e '- IV, Ciphertext and Tag Files Saved in Sender Public Directory -\n'
sleep 1

complete_ciphertext_path="${sender_dir}${public_dir}complete_ciphertext.pem"

# Concatenate ephemeral public key, IV, ciphertext, and tag into a single file, saving the file in sender's public directory
cat ${sender_dir}${public_dir}ephpubkey.pem > "${complete_ciphertext_path}"
echo "-----BEGIN AES-128-CBC IV-----" >> "${complete_ciphertext_path}"
openssl enc -a -in ${sender_dir}${public_dir}iv.bin >> "${complete_ciphertext_path}"
echo "-----END AES-128-CBC IV-----" >> "${complete_ciphertext_path}"
echo "-----BEGIN AES-128-CBC CIPHERTEXT-----" >> "${complete_ciphertext_path}"
openssl enc -a -in ${sender_dir}${public_dir}ciphertext.bin >> "${complete_ciphertext_path}"
echo "-----END AES-128-CBC CIPHERTEXT-----" >> "${complete_ciphertext_path}"
echo "-----BEGIN SHA256-HMAC TAG-----" >> "${complete_ciphertext_path}"
openssl enc -a -in ${sender_dir}${public_dir}tag.bin >> "${complete_ciphertext_path}"
echo "-----END SHA256-HMAC TAG-----" >> "${complete_ciphertext_path}"

echo -e '\nComplete Ciphertext Formatted'
echo -e '- Complete Ciphertext File Saved in Sender Public Directory -\n'
sleep 1

echo -e '\nEncryption Process Finalized\n'
echo -e '- Complete Ciphertext File Start -\n'
echo "$(cat "${complete_ciphertext_path}")"
echo -e '\n- Complete Ciphertext File End -\n'
sleep 1