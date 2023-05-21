#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo 'Execution Root Permissions Are Required'
  exit
fi

chmod 700 ./merkle-tree/app.sh
chmod 700 ./public-key-encryption/app.sh