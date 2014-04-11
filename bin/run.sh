#!/bin/bash

# Check skipping auto start for varnish
[ -z "$VARNISH_SKIP_AUTO_START" ] && echo "VARNISH_SKIP_AUTO_START env variable is set so skipping running varnish.." && exit 0;

# Replace variables in the varnish config file

replace_vars() {
  OUTPUT=$(echo $1 | sed -e 's/.source//');
  SOURCE=$1

  eval "cat <<EOF
  $(<$SOURCE)
EOF
  " > $OUTPUT
}

replace_vars '/etc/varnish/default.vcl.source'

# Starts the varnish server
varnishd -a $LISTEN_ADDR:$LISTEN_PORT -T $TELNET_ADDR:$TELNET_PORT -f $VCL_FILE -s file,/var/cache/varnish.cache,$CACHE_SIZE -F
