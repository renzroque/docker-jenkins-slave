#!/bin/bash

if [ -n "${SOCAT_LOCAL_PORT}" ] && [ -n "${SOCAT_REMOTE_HOST}" ] && [ -n "${SOCAT_REMOTE_PORT}" ] ; then
  echo Connecting to ${SOCAT_REMOTE_HOST}:${SOCAT_REMOTE_PORT} via ${SOCAT_LOCAL_PORT} ...
  exec socat -t 100000000 TCP4-LISTEN:${SOCAT_LOCAL_PORT},fork,reuseaddr TCP4:${SOCAT_REMOTE_HOST}:${SOCAT_REMOTE_PORT}
fi
