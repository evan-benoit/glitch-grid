#!/usr/bin/env bash

# How long to wait for everything to come up before starting the test?
START_DELAY=${START_DELAY:-10}
# What number to stop checking at
STOP_AT=${STOP_AT:-200}

# Check the consistency of the system when the counter is a multiple of what number?
CHECK_WHEN_MULTIPLE_OF=${CHECK_WHEN_MULTIPLE_OF:-5}
CONTROL_SERVER=$1
if [[ -z "${CONTROL_SERVER}" ]]
then
    echo "Usage: $0 <control_server>"
    exit 1
fi

# Wait a bit for the other services to come up
echo -n "Waiting ${START_DELAY} seconds for the storage system to become available ... "
sleep ${START_DELAY}
echo "done."


outfile="/tmp/healthcheck.out"
actual=0

#loop until actual >= STOP_AT
while true; do
    http_code=$(curl -s -o "${outfile}" -w "%{http_code}" "http://${CONTROL_SERVER}")
    actual=$(<"${outfile}")
    actual=${actual//[!0-9]/}   # strip non-digits

    # default to 0 if empty
    if [[ -z "$actual" ]]; then
        actual=0
    fi

    echo "HttpStatus=${http_code} Actual=${actual}"

    if [[ "$actual" -ge "$STOP_AT" ]]; then
        echo "Reached target: $actual >= $STOP_AT"
        break
    fi

    sleep 1
done