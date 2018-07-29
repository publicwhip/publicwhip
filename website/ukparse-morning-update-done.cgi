#!/bin/sh

cat NOW >/dev/null 2>/dev/null <<EOF
/home/publicwhip/www.publicwhip.org.uk/build/dailyupdate
EOF

cat <<EOF
Content-Type: text/plain

Job scheduled.
EOF

