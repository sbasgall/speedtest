#!/bin/sh

OUTPUT=`speedtest-cli --json`

UPLOAD="$(echo $OUTPUT | jq '.["upload"]')"
DOWNLOAD="$(echo $OUTPUT | jq '.["download"]')"
PING="$(echo $OUTPUT | jq '.["ping"]')"
SERVER_LAT_STRING="$(echo $OUTPUT | jq '.["server"]["lat"]')"
SERVER_LAT="$(echo $SERVER_LAT_STRING | sed 's|[^0-9.]||g')"
SERVER_LON_STRING="$(echo $OUTPUT | jq '.["server"]["lon"]')"
SERVER_LON="$(echo $SERVER_LON_STRING | sed 's|[^0-9.]||g')"

cat <<EOF | curl --data-binary @- http://192.168.1.8:9091/metrics/job/speedtest/instance/$HOSTNAME
  # TYPE download gauge
  # HELP download download speed
  speedtest{label="download"} $DOWNLOAD
  # TYPE upload gauge
  # HELP upload upload speed
  speedtest{label="upload"} $UPLOAD
  # TYPE ping gauge
  # HELP ping ping time
  speedtest{label="ping"} $PING
  # TYPE server_latitude gauge
  # HELP server_latitude server latitude from speedtest-cli response
  speedtest{label="server_latitude"} $SERVER_LAT
  # TYPE server_longitude gauge
  # HELP server_longitude server longitude from speedtest-cli response
  speedtest{label="server_longitude"} $SERVER_LON
EOF
