#!/bin/bash

# This script does not need to be changed for certbots DNS challenge.
# Please see the .dedynauth file for authentication information.

(
if [ ! -f .dedynauth ]; then
    DEDYNAUTH=`pwd`/.dedynauth
    >&2 echo "File $DEDYNAUTH not found. Please place .dedynauth file in appropriate location."
    exit 1
fi

source .dedynauth

if [ -z "$DEDYN_TOKEN" ] ; then
    DEDYNAUTH=`pwd`./dedynauth
    >&2 echo "Variable \$DEDYN_TOKEN not found. Please set DEDYN_TOKEN=(your dedyn.io token) to your dedyn.io access token in $DEDYNAUTH, e.g."
    >&2 echo 
    >&2 echo "DEDYN_TOKEN=d41d8cd98f00b204e9800998ecf8427e"
    exit 2
fi

if [ -z "$DEDYN_NAME" ] ; then
    DEDYNAUTH=`pwd`./dedynauth
    >&2 echo "Variable \$DEDYN_NAME not found. Please set DEDYN_NAME=(your dedyn.io name) to your dedyn.io name in $DEDYNAUTH, e.g."
    >&2 echo
    >&2 echo "DEDYN_NAME=foobar.dedyn.io"
    exit 3
fi

if [[ ! $(type -P curl) ]] ; then
    >&2 echo "Please install curl to use certbot with dedyn.io."
    exit 4
fi

>&2 echo "Setting challenge to ${CERTBOT_VALIDATION} ..."

# Figure out subdomain infix by removing zone name and trailing dot
# foobar.dedyn.io gives "" while a.foobar.dedyn.io gives ".a"
domain=.$CERTBOT_DOMAIN
infix=${domain%.$DEDYN_NAME}

args=( \
    '-Ss' \
    '-H' "Authorization: Token $DEDYN_TOKEN" \
    '-H' 'Accept: application/json' \
    '-H' 'Content-Type: application/json' \
    '-d' '[{"subname":"_acme-challenge'"$infix"'", "type":"TXT", "records":["\"'"$CERTBOT_VALIDATION"'\""], "ttl":60}]' \
    '-o' '/dev/null' \
)

# set ACME challenge (overwrite if possible, create otherwise)
curl -X PUT "${args[@]}" -f "https://desec.io/api/v1/domains/$DEDYN_NAME/rrsets/"

>&2 echo "Verifying challenge is set correctly. This can take up to 2 minutes."
>&2 echo "Current Time: `date`"

for i in `seq 1 60`;
do

	CURRENT=$(host -t TXT "_acme-challenge$infix.$DEDYN_NAME" ns1.desec.io | grep -- "$CERTBOT_VALIDATION")
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

