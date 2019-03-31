#!/bin/sh

# Setup default settings file
[ ! -f /config/settings.json ] && cp /var/lib/transmission-daemon/info/settings.json /config/settings.json

# Backup and clean log file on every start
if [ -f /config/transmission.log ]; then
    gzip -c /config/transmission.log > /config/transmission.$(date +%Y%m%d-%H%M%S).log.gz
    rm /config/transmission.log
fi

# Setup log settings, we need a symlink to logfile inside the web directory
touch /config/transmission.log
rm -f /usr/share/transmission/web/transmission.log 2>/dev/null
ln -s /config/transmission.log  /usr/share/transmission/web/transmission.log

# Setup default download-complete script
[ ! -f /config/download-complete ] && cp /var/lib/transmission-daemon/info/download-complete /config/download-complete
chmod +x /config/download-complete

export TR_USERNAME=${TR_USERNAME:-"${USERNAME:-"transmission"}"}
export TR_PASSWORD=${TR_PASSWORD:-"${PASSWORD:-"transmission"}"}
export LOG_FILE=/config/transmission.log

echo "Starting transmission-daemon..."
echo "Web UI credentials: ${TR_USERNAME} / ${TR_PASSWORD}"
echo "Log file          : ${LOG_FILE}"
exec /usr/bin/transmission-daemon --foreground --config-dir /config --log-info \
    --username "${TR_USERNAME}" --password "${TR_PASSWORD}" \
    --logfile /config/transmission.log
