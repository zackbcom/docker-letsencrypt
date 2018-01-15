#!/usr/bin/with-contenv bash

echo "<------------------------------------------------->"
echo
echo "<------------------------------------------------->"
echo "cronjob running on "$(date)
echo "Running certbot renew"
. /config/donoteditthisfile.conf
if [ "$ORIGDNSVAL" = "true" ]; then
  echo "Performing DNS validation"
  cetbot -n renew --manual --manual-auth-hook /config/authenticator.sh --manual-cleanup-hook /config/cleanup.sh --post-hook "s6-svc -h /var/run/s6/services/nginx ; cd /config/keys/letsencrypt && openssl pkcs12 -export -out privkey.pfx -inkey privkey.pem -in cert.pem -certfile chain.pem -passout pass:"
else
  echo "Performing http/s validation"
  certbot -n renew --standalone --pre-hook "s6-svc -d /var/run/s6/services/nginx" --post-hook "s6-svc -u /var/run/s6/services/nginx ; cd /config/keys/letsencrypt && openssl pkcs12 -export -out privkey.pfx -inkey privkey.pem -in cert.pem -certfile chain.pem -passout pass:"
fi
