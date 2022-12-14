#!/bin/bash

SCRIPT_DIR=`dirname "$(readlink -f "$BASH_SOURCE")"`
ROOT_DIR=${SCRIPT_DIR%/*}
echo $ROOT_DIR
CLIENT_BUILD_DIR=$SCRIPT_DIR/dist

clientBuildFile=$SCRIPT_DIR/dist/client-app.zip

# for testing environment variables from .env
export $(grep -v '^#' $SCRIPT_DIR/.env | xargs -d '\n')

if [ -e "$clientBuildFile" ]; then
  rm "$clientBuildFile"
  echo "$clientBuildFile was removed."
fi

cd $SCRIPT_DIR && npm run build --configuration=$ENV_CONFIGURATION --output-path=$CLIENT_BUILD_DIR
#7z a -tzip $clientBuildFile $CLIENT_BUILD_DIR/*
zip -r $clientBuildFile $CLIENT_BUILD_DIR/*
echo "Client app was built with $ENV_CONFIGURATION configuration."

: 'NOTE: for compressing files was used 7zip program (by adding it to `PATH` env variable), as script
was writing on Win10 and this OS  do not support "zip" command without additional installations.
Probably, for others OS will be more suitable next command:'
#zip -r $clientBuildFile $CLIENT_BUILD_DIR/*

