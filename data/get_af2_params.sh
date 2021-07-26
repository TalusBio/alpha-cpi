#!/bin/bash

SOURCE_URL=https://storage.googleapis.com/alphafold/alphafold_params_2021-07-14.tar
PARAMS_DIR=./alphafold/data/params
PARAMS_PATH="${PARAMS_DIR}/$(basename $SOURCE_URL)"

mkdir --parents $PARAMS_DIR
wget -O $PARAMS_PATH $SOURCE_URL

tar --extract --verbose --file=$PARAMS_PATH --directory=$PARAMS_DIR --preserve-permissions
rm $PARAMS_PATH