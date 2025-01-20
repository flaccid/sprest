#!/bin/sh -e

/usr/local/bin/steampipe service start --show-password

exec "$@"
