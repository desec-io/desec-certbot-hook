#!/bin/bash

# This script does not need to be changed for certbots DNS challenge.
# Please see the .dedynauth file for authentication information.

(
if [ ! -f .dedynauth ]; then
    PATH=`pwd`/.dedynauth
    >&2 echo "File $PATH not found. Please place .dedynauth file in appropriate location."
    exit 1
fi

source .dedynauth

if [ -z "$DEDYN_TOKEN" ] ; then
    PATH=`pwd`./dedynauth
    >&2 echo "Variable \$DEDYN_TOKEN not found. Please set DEDYN_TOKEN=(your dedyn.io token) to your dedyn.io access token in $PATH, e.g."
    >&2 echo 
    >&2 echo "DEDYN_TOKEN=d41d8cd98f00b204e9800998ecf8427e"
    exit 2
fi

if [ -z "$DEDYN_NAME" ] ; then
    PATH=`pwd`./dedynauth
    >&2 echo "Variable \$DEDYN_NAME not found. Please set DEDYN_NAME=(your dedyn.io name) to your dedyn.io name in $PATH, e.g."
    >&2 echo
    >&2 echo "DEDYN_NAME=foobar.dedyn.io"
    exit 3
fi

if [[ ! $(type -P curl) ]] ; then
    >&2 echo "Please install curl to use certbot with dedyn.io."
    exit 4
fi

>&2 echo "Setting challenge to ${CERTBOT_VALIDATION}..."

TOKEN=$CERTBOT_VALIDATION

# be silent unless error, server response will still be written to output
curl -X PATCH https://desec.io/api/v1/domains/$DEDYN_NAME/ \
    -Ss \
    -H 'Accept: application/json' \
    -H "Authorization: Token $DEDYN_TOKEN" \
    -H 'Content-Type: application/json' \
    -d "{\"acme_challenge\":\"$TOKEN\"}" \
    > /dev/null

>&2 echo "Verifying challenge is set correctly. This can take up to 2 Minutes."
>&2 echo "Current Time: `date`"

for i in `seq 1 60`;
do

	CURRENT=$(host -t TXT _acme-challenge.$DEDYN_NAME ns1.desec.io | grep $TOKEN)
	if [ ! -z "$CURRENT" ]; then
		break
	fi
	sleep 2

done

if [ -z "$CURRENT" ]; then
	>&2 echo "Token could not be published. Please check your dedyn credentials."
	exit 5
fi

>&2 echo "Token published. Returning to certbot."

)

