#!/bin/bash
FB_GRAPH_URL_BASE="https://graph.facebook.com/?ids="
UNISHARP_MAP_URL_BASE="http://map.unisharp.net/COSCUP_2013/"
UNISHARP_MAP_NICKNAME_API_BASE="http://map.unisharp.net/api/users/?id="

UIDS=$@

if [ -z "$UIDS" ]; then
    echo "Usage: ./get-score.sh uid1 uid2 uid3..." >&2
    exit 1
fi

CMD_UTF8_DECODE="native2ascii -encoding UTF-8 -reverse"

which curl > /dev/null || (echo no curl command found >&2 && exit 1)
which native2ascii > /dev/null || echo Oops, native2ascii not found, UTF-8 string not decoded >&2
which native2ascii > /dev/null || CMD_UTF8_DECODE=cat

for uid in $UIDS; do
    [[ "`curl -s $UNISHARP_MAP_NICKNAME_API_BASE$uid`" =~ \"nickname\":\"([^\"]*)\" ]]  && name=${BASH_REMATCH[1]}
    [[ "`curl -s $FB_GRAPH_URL_BASE$UNISHARP_MAP_URL_BASE$uid`" =~ shares\":([0-9]+) ]] && score=${BASH_REMATCH[1]}
    echo $name:$score | $CMD_UTF8_DECODE
done
