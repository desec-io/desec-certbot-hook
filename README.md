# dedyn.io certbot DNS challenge automatization

The certbot hook script of this repository has been retired in favor of
[certbot-dns-desec](https://pypi.org/project/certbot-dns-desec/).

## How to Migrate

1. Remove certbot configuration for your domain.
1. [Delete the token](https://desec.readthedocs.io/en/latest/auth/tokens.html#deleting-a-token)
    from the `.dedynauth` file from your deSEC account.
1. Remove `.dedynauth` file that belonged to the hook script.
1. Follow instructions for [certbot-dns-desec](https://pypi.org/project/certbot-dns-desec/).
