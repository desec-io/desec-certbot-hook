# dedyn.io certbot DNS challenge automatization
With the help of this hook script, you can obtain your Let's Encrypt certificate using 
certbot with authorization provided by the DNS challenge mechanism, that is, you will
not need a running web server or any port forwarding to your local machine.


## Quick Start Guide for Beginners
To obtain a certificate for your dedyn.io domain right away, follow these steps.

1. **Install certbot.** There are many ways to install certbot, depending on your distribution
and preference. Please follow instructions on https://certbot.eff.org/

2. **Install hook script.** To authenticate your dedyn.io domain against Let's Encrypt
using the DNS challenge mechanism, you will need to update your domain according to
instructions provided by Let's Encrypt. The hook script in this repository automatizes this
process for you. To use it, download the `hook.sh` and `.dedynauth` files and place them
into a directory of your choice.

3. **Set up hook script.** You need to provide your dedyn.io credentials to the hook script,
so the script can update your domain information on your behalf. To do so, edit the `.dedynauth`
file to look something like

        export DEDYN_TOKEN=9e6ad...your token...64c53bd
        export DEDYN_NAME=yourdomain.dedyn.io
    
4. **Run certbot.** To obtain your certificate, run certbot in manual mode, setup to use the
dedyn hook scripts you just downloaded. For detailed instructions on how to use certbot,
please refer to the certbot manual. A typical use of certbot is listed below. Please notice
that you need to insert your domain name one more time. (Also, for users not familiar with bash,
please note that you need to remove the `\` if you reformat the command to fit one line.) Depending
on how you installed certbot, you may need to replace `./certbot-auto` with just `certbot-auto`.
Please also note that the hook script may wait up to two minutes to be sure that the challenge
was correctly published.

         ./certbot-auto --manual \
         --text \
         --preferred-challenges dns \
         --manual-auth-hook ./hook.sh \
         --manual-cleanup-hook ./hook.sh \
         -d "YOURDOMAINNAME.dedyn.io" \
         certonly

## Contribution
Please do not hesitate to contact us with any improvements of this work. All work should be licensed
under MIT license or compatible.

