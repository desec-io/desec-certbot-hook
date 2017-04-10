#!/bin/bash

# This script does not need to be changed for certbots DNS challenge.
# Please see the .dedynauth file for authentication information.

(
if [ ! -f .dedynauth ]; then
    PATH=`pwd`/.dedynauth
    echo "File $PATH not found. Please place .dedynauth file in appropriate location."
    exit 1
fi

source .dedynauth

if [ -z "$DEDYN_TOKEN" ] ; then
    PATH=`pwd`./dedynauth
    echo "Variable \$DEDYN_TOKEN not found. Please set DEDYN_TOKEN=(your dedyn.io token) to your dedyn.io access token in $PATH, e.g."
    echo 
    echo "DEDYN_TOKEN=d41d8cd98f00b204e9800998ecf8427e"
    exit 2
fi

if [ -z "$DEDYN_NAME" ] ; then
    PATH=`pwd`./dedynauth
    echo "Variable \$DEDYN_NAME not found. Please set DEDYN_NAME=(your dedyn.io name) to your dedyn.io name in $PATH, e.g."
    echo
    echo "DEDYN_NAME=foobar.dedyn.io"
    exit 3
fi

if [[ ! $(type -P curl) ]] ; then
    echo "Please install curl to use certbot with dedyn.io."
    exit 4
fi

TOKEN=$CERTBOT_VALIDATION

# be silent unless error, server response will still be written to output
curl -X PATCH https://desec.io/api/v1/domains/$DEDYN_NAME/ \
    -S \
    -H 'Accept: application/json' \
    -H "Authorization: Token $DEDYN_TOKEN" \
    -H 'Content-Type: application/json' \
    -d "{\"acme_challenge\":\"$TOKEN\"}"

)

