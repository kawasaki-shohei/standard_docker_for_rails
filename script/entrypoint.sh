#!/bin/bash
set -e
rm -f /usr/src/wod/tmp/pids/server.pid
exec "$@"