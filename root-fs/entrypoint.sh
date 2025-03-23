#!/bin/sh

config_val() {
    grep "${1}" /var/lib/transmission-daemon/info/settings.json | grep -v "\-enabled" \
    | cut -d":" -f2 | sed 's/,//g' | sed 's/ //g' | sed 's/"//g'
}

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

mkdir -p /downloads/.transmission-incomplete

export TR_USERNAME=${TR_USERNAME:-"${USERNAME:-"transmission"}"}
export TR_PASSWORD=${TR_PASSWORD:-"${PASSWORD:-"transmission"}"}
export LOG_FILE=/config/transmission.log
config_file="/var/lib/transmission-daemon/info/settings.json"
PORT="$(config_val "rpc-port")"
ROOT_URL="$(config_val "rpc-url")"

echo "------------------------------------------------------------"
echo "Starting transmission-daemon..."
echo "Transmission Web  : http://localhost:${PORT}${ROOT_URL}web/"
echo "Credentials       : ${TR_USERNAME} / ${TR_PASSWORD}"
echo "Web Log           : http://localhost:${PORT}${ROOT_URL}web/log.html"
echo "Log file          : ${LOG_FILE}"
printf "Downloads         : "; config_val "download-dir"
printf "Incomplete        : "; config_val "incomplete-dir"
printf "Watch             : "; config_val "watch-dir"
printf "Complete script   : "; config_val "script-torrent-done-filename"
echo "------------------------------------------------------------"
echo "Start transmission-daemon"
exec /usr/bin/transmission-daemon --foreground --config-dir /config --log-info \
    --username "${TR_USERNAME}" --password "${TR_PASSWORD}" \
    --logfile /config/transmission.log
