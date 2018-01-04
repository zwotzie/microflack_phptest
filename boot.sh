#!/bin/sh -e

# start service discovery task in the background
#if [ "$SERVICE_URL" != "" ]; then
#    python3 -c "from microflack_common.container import register; register()" &
#fi

#!/bin/sh

# Execute project specific setup script.
if [ -e /app/setup.sh ]; then
	echo "[i] Running project setup script."
	. /app/setup.sh
fi

# Display PHP error's or not
#if [[ "$ERRORS" != "1" ]] ; then
#    php_flag[display_errors] = off >> /etc/php7/php-fpm.conf
#else
#    echo php_flag[display_errors] = on >> /etc/php7/php-fpm.conf
#fi

echo "[i] Starting nginx with supervisor..."

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
# sleep 3600
