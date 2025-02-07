#!/bin/bash
set -e

# Postfix smart-host configuration via environment variables
    touch /etc/postfix/main.cf
    # Domain-based outgoing email relay policy
    postconf -e "transport_maps = hash:/etc/postfix/transport"
    postconf -e "smtp_tls_security_level = encrypt"
    postconf -e "smtp_tls_note_starttls_offer = yes"


if [ -z "$1" ]; then
    exec /usr/lib/postfix/sbin/master -c /etc/postfix/ -d
fi

exec "$@"
